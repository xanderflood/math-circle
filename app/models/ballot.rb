class Ballot < ApplicationRecord
  belongs_to :student
  belongs_to :course
  belongs_to :semester
  has_many :ballot_preferences

  validates :student, uniqueness: { scope: :semester }
  validate :course_in_semester

  # validations
  def course_in_semester
    course.semester == semester
  end

  # business logic
  def ordered_preferences
    ballot_preferences.all.sort_by(&:preference).map(&:section)
  end
end
