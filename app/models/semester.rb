class Semester < ApplicationRecord
  default_scope { order(start: :desc) }

  has_many :courses, dependent: :destroy
  has_many :sections, through: :courses, dependent: :destroy
  has_many :events, through: :sections
  has_many :rollcalls, through: :events

  has_many :ballots, dependent: :destroy
  has_many :registrees, dependent: :destroy
  has_many :lotteries, dependent: :destroy

  has_many :special_events, dependent: :destroy
  has_many :special_registrees, through: :special_events

  validates :name, presence: { allow_blank: false, message: "must be provided." }
  validate :end_after_start

  ### state tracking ###
  state_machine(initial: :hidden) do
    # TODO: put email callbacks here

    before_transition hidden: :lottery_open, do: :reset_for_publish

    event(:publish) {
      transition hidden: :lottery_open
    }
    event(:close_lottery) {
      transition lottery_open: :lottery_closed
    }
    event(:run) {
      transition [:lottery_closed, :lottery_done] => :lottery_done
    }
    event(:open_registration) {
      transition lottery_done: :registration_open,
                       closed: :registration_open
    }
    event(:close_registration) {
      transition registration_open: :closed
    }
  end

  LOTTERY_STATES = ["lottery_closed", "lottery_done", "lottery_open"]
  REGISTRATION_STATE = ["registration_open", "closed"]

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
  def lottery?
    LOTTERY_STATES.include? self.state
  end

  def registration?
    REGISTRATION_STATE.include? self.state
  end

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
  def reset_for_publish
    Student.update_all(level: :unspecified, school_grade: nil)
    Semester.where.not(state: [:hidden, :closed]).update(state: :closed)
  end

  def end_after_start
    errors.add(:end, 'must be later than the start date.') if self.end <= self.start
  end
end
