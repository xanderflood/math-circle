class EventGroup < ApplicationRecord
  has_many :events
  belongs_to :course
end
