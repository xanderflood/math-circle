class Semester < ApplicationRecord
  default_scope { order(start: :desc) }

  has_many :courses
  has_many :sections, through: :courses
  has_many :special_events
  has_many :ballots

  attr_accessor :transition_errors
  attr_accessor :target_lottery

  validates :name, presence: { allow_blank: false, message: "must be provided." }
  validate :end_after_start

  # before_save :maybe_erase_student_levels, if: :current_changed?
  after_save :only_one_current_semester

  state_machine(initial: :hidden) do
    # TODO: put email callbacks here

    before_transition [:lottery_closed, :lottery_done] => :lottery_done, do: :commit_lottery

    event(:publish) { transition         hidden:    :lottery_open }
    event(:hide)    { transition all - [:hidden] => :hidden       }

    event(:close_lottery) { transition                    lottery_open:    :lottery_closed }
    event(:open_lottery)  { transition [:lottery_closed, :lottery_done] => :lottery_open   }

    # These need notifications
    event(:run) { transition [:lottery_closed, :lottery_done] => :lottery_done }

    event(:skip_lottery)      { transition lottery_closed: :registration_open }
    event(:open_registration) { transition   lottery_done: :registration_open,
                                                   closed: :registration_open }

    event(:close_registration) { transition registration_open: :closed }
  end

  def self.current
    self.where.not(state: 'hidden').limit(1).first
  end

  def self.current_courses(level=nil)
    courses = Semester.current.courses
    courses = courses.where(level: level) if level

    courses
  end

  def maybe_erase_student_levels
    return unless self.current == true

    Student.update_all(level: :unspecified)
  end

  def current?; self.state != 'hidden'; end

  def roster
    @roster ||= self.courses.map(&:roster).inject([], :+)
  end

  def waitlist
    @waitlist ||= self.courses.map(&:waitlist).inject([], :+)
  end

  def lottery_students

  end

  def all_students
    # if self.
    @all_students ||= roster + waitlist
  end

  def everyone
    self.ballots.map(&:student_id)
  end

  def state_description
    SemesterStateHelper::STATE_DESCRIPTIONS[self.state]
  end

  protected
  ### callbacks ###
  def only_one_current_semester
    Semester.where.not(id: self.id).update_all(state: 'hidden') if current?
  end

  def end_after_start
    errors.add(:end, 'must be later than the start date.') if self.end <= self.start
  end

  def commit_lottery
    @target_lottery.commit
  end
end
