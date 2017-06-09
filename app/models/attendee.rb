class Attendee < ApplicationRecord
  has_one :student
  has_one :parent_profile

  validate :valid_refs?, on: [:create, :update]

  def valid_refs?; student.nil? ^ parent_profile.nil?; end

  def parent?; student.nil?; end
end
