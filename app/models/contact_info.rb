class ContactInfo < ApplicationRecord
  belongs_to :parent_profile

  validates :attribute, phone: true
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: [:create, :update] }
  validate :valid_address?, on: [:create, :update]

  def valid_address?
    validator = AddressValidator::Validator.new
    response = validator.validate(address_hash)

    if response.valid? && response.residential?
      #
      # Here, we should replace it with the new updated address maybe?
      #

      true
    else
      false
    end
  end

  def address_hash
    {
      street1: self.street1,
      street2: self.street2,
      city: self.city,
      state: self.state,
      zip: self.zipcode,
      country: self.country
    }
  end
end
