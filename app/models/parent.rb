class Parent < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :students

  has_one :parent_profile
  alias :profile :parent_profile

  def profile_or_new
    profile || ParentProfile.new(parent_id: self.id)
  end
end
