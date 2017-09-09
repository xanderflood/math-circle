class Parent < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :students, dependent: :destroy
  has_one :parent_profile, dependent: :destroy

  alias :profile :parent_profile

  def name; self.profile.name; end

  def profile_or_new
    profile || ParentProfile.new(parent_id: self.id)
  end
end
