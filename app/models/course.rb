class Course < ApplicationRecord
  belongs_to :semester
  has_many :event_groups

  enum grade: [ :nine, :ten, :twelve ]
end
