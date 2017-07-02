class BallotPreference < ApplicationRecord
  self.table_name = "ballots_event_groups"

  belongs_to :ballot
  belongs_to :semester
  has_one :section, as: :event_group

  validates :preference, uniqueness: { scope: :ballot }
  validate :event_in_ballot

  def initialize(attributes={})
    super

    self.semester ||= ballot.semester
  end

  # validations
  def event_in_ballot
    event_group.course == ballot.course
  end
end
