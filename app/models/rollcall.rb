class Rollcall < ApplicationRecord
  belongs_to :event

  before_create :set_date_to_today

  private
    def set_date_to_today
      self.date = Date.today
    end
end
