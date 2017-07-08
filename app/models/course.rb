class Course < ApplicationRecord
  default_scope{ order(created_at: :desc) }

  belongs_to :semester
  has_many :sections, class_name: "EventGroup"

  enum grade: GradesHelper::GRADES
end
