class ContactInfo < ApplicationRecord
  NAMELESS_FIELDS = [:email, :phone, :street1, :street2, :city, :state, :zip].freeze
  FIELDS = ([:first_name, :last_name] + NAMELESS_FIELDS).freeze

  has_one :parent_profile

  belongs_to :address

  validates :phone, phone: true
  validates_format_of :email, with: EmailHelper::OPTIONAL_EMAIL
end
