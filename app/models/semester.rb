class Semester < ApplicationRecord
  default_scope { order(created_at: :desc) }

  has_many :courses
  has_many :special_events

  validates :name, presence: { allow_blank: false, message: "must be provided." }

  enum state: [ :prereg, :reg, :late_reg, :archived ]
  STATE_DESCRIPTION = [
    "hidden from users",
    "open for registration",
    "open for late registration",
    "closed",
    "archived"
  ]

  def state_description
    Semester::STATE_DESCRIPTION[state.to_i]
  end
end
