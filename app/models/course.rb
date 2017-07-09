class Course < ApplicationRecord
  default_scope{ order(created_at: :desc) }

  belongs_to :semester
  has_many :sections, class_name: "EventGroup"

  validates :name, presence: { allow_blank: false, message: "must be provided." }

  enum grade: GradesHelper::GRADES
end
