class Rollcall < ApplicationRecord
  belongs_to :event

  before_create :set_date_to_today

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
