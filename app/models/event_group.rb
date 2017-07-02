class EventGroup < ApplicationRecord
  has_many :events
  belongs_to :course

  attr_accessor :start_date, :end_date

  # TODO: Add validations and code to create all the child events

  enum wday: DayHelper::DAYS

  def description
    "#{name} - #{wday} @ #{time}"
  end
end
