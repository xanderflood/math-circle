class SpecialRegistree < ApplicationRecord
  belongs_to :special_event
  belongs_to :parent

  validate :check_event_capacity, unless: :unlimited?

  def unlimited?; self.special_event.unlimited?; end

  def check_event_capacity
    event_occupancy =
      self.special_event
          .special_registrees
          .where.not(id: self.id)
          .map(&:value).inject(0, :+)

    total = event_occupancy + value
    if total > self.special_event.capacity
      space = self.special_event.capacity - total

      errors.add(:base, "This event has only #{total} spaces left.")
    end
  end
end
