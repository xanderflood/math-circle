class Semester < ApplicationRecord
  has_many :courses
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
