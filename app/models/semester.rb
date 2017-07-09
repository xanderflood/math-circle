class Semester < ApplicationRecord
  default_scope { order(created_at: :desc) }
  after_save :only_one_current_semester

  has_many :courses
  has_many :special_events

  validates :name, presence: { allow_blank: false, message: "must be provided." }
  validate :end_after_start

  enum state: [ :prereg, :reg, :late_reg, :archived ]
  STATE_DESCRIPTION = [
    "hidden from users",
    "open for registration",
    "open for late registration",
    "closed",
    "archived"
  ]

  def self.current
    self.where(current: true).limit(1).first
  end

  def self.course_info(grade=nil)
    courses = Semseter.current.coures
    courese = courses.where(grade: grade) if grade
  end

  def state_description
    Semester::STATE_DESCRIPTION[state.to_i]
  end

  protected
  def only_one_current_semester
    Semester.where(current: true).where('id != ?', id).update_all(current: false) if current
  end

  def end_after_start
    errors.add(:end, 'must be later than the start date.') if self.end <= self.start
  end
end
