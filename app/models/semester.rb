class Semester < ApplicationRecord
  default_scope { order(start: :desc) }

  has_many :courses, dependent: :destroy
  has_many :special_events, dependent: :destroy
  has_many :sections, through: :courses, dependent: :destroy
  has_many :ballots, dependent: :destroy
  has_many :registrees, dependent: :destroy
  has_many :lotteries, dependent: :destroy

  attr_accessor :transition_errors
  attr_accessor :target_lottery

  validates :name, presence: { allow_blank: false, message: "must be provided." }
  validate :end_after_start

  ### state tracking ###
  state_machine(initial: :hidden) do
    # TODO: put email callbacks here

    before_transition [:lottery_closed, :lottery_done] => :lottery_done, do: :commit_lottery
    before_transition                             all:    :closed, do: :reset_all_levels

    event(:publish) { transition         hidden:    :lottery_open }
    # event(:hide)    { transition all - [:hidden] => :hidden       }

    event(:close_lottery) { transition                    lottery_open:    :lottery_closed }
    # event(:open_lottery)  { transition [:lottery_closed, :lottery_done] => :lottery_open   }

    event(:run) { transition [:lottery_closed, :lottery_done] => :lottery_done }

    event(:open_registration) { transition lottery_done: :registration_open,
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

  def self.current_special_events
    self.current.special_events.where('date >= ?', Date.today).all
  end

  def current?; Semester.current == self; end

  ### methods ###
  def applicants
    self.ballots.map(&:student)
  end

  def roster
    @roster ||= self.courses.map(&:roster).inject([], :+)
  end

  def waitlist
    @waitlist ||= self.courses.map(&:waitlist).inject([], :+)
  end

  def all_students
    @all_students ||= roster + waitlist
  end

  def state_description
    SemesterStateHelper::STATE_DESCRIPTIONS[self.state]
  end

  protected
  ### callbacks ###
  def reset_all_levels
    Student.update_all(level: :unspecified)
  end

  # TODO: this should be a validation, when a semseter gets published
  # def ensure_all_other_semesters_are_closed
  #   Semester.all.all? { |s| s.closed? } # returns false unless all semesters are closed
  # end

  def end_after_start
    errors.add(:end, 'must be later than the start date.') if self.end <= self.start
  end

  def commit_lottery
    @target_lottery.commit
  end
end
