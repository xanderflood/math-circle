class CreateJoinTableBallotPreferences < ActiveRecord::Migration[5.0]
  def change
    create_join_table :ballots, :event_groups do |t|
      t.index [:ballot_id, :event_group_id]
      t.index [:event_group_id, :ballot_id]

      t.integer :preference
    end
  end
end
