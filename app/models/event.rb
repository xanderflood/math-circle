class Event < ApplicationRecord
  default_scope{ order(when: :asc, time: :asc)}

  belongs_to :section, class_name: "EventGroup"

  def date_str
    I18n.l self[:when]
  end

  def time_str
    I18n.l self[:time].to_time
  end

  def description
    if name.nil? || name.empty?
      "#{date_str} @ #{time_str}"
    else
      "#{name} - #{date_str} @ #{time_str}"
    end
  end
end
