class Course < ApplicationRecord
  default_scope{ order(created_at: :desc) }

  belongs_to :semester
  has_many :sections, class_name: "EventGroup"
  has_many :ballots

  serialize :waitlist, Array

  # TODO: unrequire "name" and replace with a "description" method
  validates :grade, presence: { allow_blank: false, message: "must be specified." }

  enum grade: GradesHelper::GRADES

  def roster
    self.sections.map(&:roster).inject([], :+)
  end

  def waitlist
    self.sections.map(&:waitlist).inject([], :+)
  end

  def all_students
    self.sections.map(&:all_students).inject([], :+)
  end

  def description
    if name
      "#{name} (grade #{grade})"
    else
      "grade #{grade}"
    end
  end
end
