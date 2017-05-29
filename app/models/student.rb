class Student < ApplicationRecord
  belongs_to :contact_info
  belongs_to :parent
end
