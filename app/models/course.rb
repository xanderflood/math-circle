class Course < ApplicationRecord
  belongs_to :semester
  has_many :sections, class_name: "EventGroup"

  enum grade: GradesHelper::GRADES
end
