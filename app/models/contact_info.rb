class ContactInfo < ApplicationRecord
  has_one :parent_profile

  belongs_to :address

  validates :phone, phone: true
  validates_format_of :email, with: EmailHelper::OPTIONAL_EMAIL
end
