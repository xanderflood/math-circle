class ParentProfile < ApplicationRecord
  belongs_to :parent

  belongs_to :primary_contact,     class_name: ContactInfo, foreign_key: :primary_contact_id
  belongs_to :emergency_contact,   class_name: ContactInfo, foreign_key: :emergency_contact_id
  belongs_to :emergency_contact_2, class_name: ContactInfo, foreign_key: :emergency_contact_2_id

  accepts_nested_attributes_for :primary_contact, :emergency_contact, :emergency_contact_2

  def primary_contact=(value)
    super unless value.is_a? Hash

    super ContactInfo.new(value)
  end
end
