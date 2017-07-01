class Student < ApplicationRecord
  belongs_to :contact_info
  belongs_to :parent
  has_many :registrees
end
