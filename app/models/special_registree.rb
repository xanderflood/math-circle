class SpecialRegistree < ApplicationRecord
  # makes form_for work with a singleton resource
  model_name.instance_variable_set(:@route_key, 'special_registree')

  belongs_to :special_event
  belongs_to :parent

  validate :check_value
  validate :check_event_capacity, unless: :unlimited?
  validate :not_passed

  def unlimited?; self.special_event.unlimited?; end

  def check_value
    if self.value.nil? || self.value <= 0
      self.errors.add(:base, "You must specify a number of people.")
    end
  end

  def check_event_capacity
    event_occupancy =
      self.special_event
          .special_registrees
          .where.not(id: self.id)
          .map(&:value).inject(0, :+)

    total = event_occupancy + value
    if total > self.special_event.capacity
      space = self.special_event.capacity - event_occupancy

      errors.add(:base, "This event has only #{space} spaces left.")
    end
  end

  ### validations ###
  def not_passed
    if self.special_event.date < Date.today
      self.errors.add(:base, "This event has already taken place.")
    end
  end
end
