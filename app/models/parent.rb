class Parent < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :students

  has_one :parent_profile
  alias :profile :parent_profile

  def profile_or_new
    profile || ParentProfile.new(parent_id: self.id,
      primary_contact_attributes:     {email: self.email},
      emergency_contact_attributes:   {},
      emergency_contact_2_attributes: {})
  end
end
