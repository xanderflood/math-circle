class Event < ApplicationRecord
  default_scope{ order(when: :asc, time: :asc)}

  belongs_to :section, class_name: "EventGroup"

  def time_str
    I18n.l self[:when]
  end

  def description
    if name.nil? || name.empty?
      "#{self.when} @ #{time_str}"
    else
      "#{name} - #{self.when} @ #{time_str}"
    end
  end
end
