class Event < ApplicationRecord
  default_scope{ order(when: :asc, time: :asc)}

  belongs_to :section, class_name: "EventGroup"

  has_one :rollcall, dependent: :destroy

  ### methods ###
  def rollcall_or_new
    Rollcall.find_by(event_id: self.id) || Rollcall.new(event: self)
  end

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
