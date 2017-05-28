class ParentProfile < ApplicationRecord
  belongs_to :parent

  has_one :contact_info, as: :primary_contact
  has_one :contact_info, as: :emergency_contact

  has_many :contact_infos, dependent: :destroy
end
