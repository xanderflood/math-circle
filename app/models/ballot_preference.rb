class BallotPreference < ApplicationRecord
  belongs_to :ballot
  belongs_to :section, class_name: "EventGroup"

  validates :section,    uniqueness: { scope: :ballot }
  validates :preference, uniqueness: { scope: :ballot }
  # validate :event_in_ballot

  # validations
  def event_in_ballot
    section.course == ballot.course
  end
end
