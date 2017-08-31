class SpecialEvent < ApplicationRecord
  belongs_to :semester

  has_many :special_registrees
  has_many :parents, through: :special_registrees

  def unlimited?; self.capacity == 0; end

  def register(parent, quantity)
    self.special_registrees.new(
      parent: parent,
      value: quantity)
  end
end
