class Registree < ApplicationRecord
  belongs_to :student
  belongs_to :event_group
  belongs_to :course, through: :event_group

  validates :one_course_per_student
  validates :student,    uniqueness: { scope: :event_group }
  validates :preference, uniqueness: { scope: [:student, :course] }

  def one_course_per_student
    student.registrees.map(&:course).uniq.count == 1
  end
end
