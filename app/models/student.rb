class Student < ApplicationRecord
  has_one :contact_info
  belongs_to :parent
  has_many :ballots

  enum grade: GradesHelper::GRADES
end
