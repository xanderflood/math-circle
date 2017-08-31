class SpecialEvent < ApplicationRecord
  belongs_to :semester

  has_many :special_registrees
  has_many :parents, through: :special_registrees

  def unlimited?; self.capacity == 0; end

  def fetch_registree(parent)
    registrees.find_by(parent: parent) ||
      registrees.new(parent: parent)
  end

  def register(parent, quantity)
    registree = fetch_registree(parent)
    registree.value = quantity

    registree.save
  end
end
