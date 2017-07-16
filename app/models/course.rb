class Course < ApplicationRecord
  default_scope{ order(created_at: :desc) }

  belongs_to :semester
  has_many :sections, class_name: "EventGroup"

  # TODO: unrequire "name" and replace with a "description" method
  validates :name, presence: { allow_blank: false, message: "must be provided." }
  validates :grade, presence: { allow_blank: false, message: "must be specified." }

  enum grade: GradesHelper::GRADES
end
