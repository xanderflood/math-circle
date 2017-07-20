class Rollcall < ApplicationRecord
  belongs_to :event

  after_initialize :set_date_to_today

  def self.for_event_id id
    Rollcall.where(event_id: id).first || Rollcall.new(event_id: id)
  end

  def enrollees
    Student.find event.event_group.roster
  end

  # def extras
  # end

  private
    def set_date_to_today
      self.date = Date.today
    end
end
