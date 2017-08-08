class Semester < ApplicationRecord
  default_scope { order(start: :desc) }
  before_save :maybe_erase_student_levels, if: :current_changed?
  after_save :only_one_current_semester

  has_many :courses
  has_many :sections, through: :courses
  has_many :special_events
  has_many :ballots

  validates :name, presence: { allow_blank: false, message: "must be provided." }
  validate :end_after_start

  enum state: [ :reg, :late_reg, :archived ]
  STATE_DESCRIPTION = [
    "open for registration",
    "open for late registration",
    "closed",
    "archived"
  ]

  def self.current
    self.where(current: true).limit(1).first
  end

  def self.current_courses(grade=nil)
    courses = Semester.current.courses
    courses = courses.where(grade: grade) if grade

    courses
  end

  def maybe_erase_student_levels
    return unless self.current == true

    Student.update_all(grade: :unspecified)
  end

  def roster
    self.courses.map(&:roster).inject([], :+)
  end

  def waitlist
    self.courses.map(&:waitlist).inject([], :+)
  end

  def all_students
    self.courses.map(&:all_students).inject([], :+)
  end

  def registrees
    self.ballots.map(&:student_id)
  end

  def state_description
    Semester::STATE_DESCRIPTION[Semester.states[state]]
  end

  protected
    def only_one_current_semester
      Semester.where('id != ?', id).update_all(current: false) if current
    end

    def end_after_start
      errors.add(:end, 'must be later than the start date.') if self.end <= self.start
    end
end
