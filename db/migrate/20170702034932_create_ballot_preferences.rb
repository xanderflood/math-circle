class CreateBallotPreferences < ActiveRecord::Migration[5.0]
  def change
    create_table :ballot_preferences do |t|
      t.references :ballot, foreign_key: true
      t.references :section, foreign_key: true
      t.integer :preference

      t.index [:ballot_id, :event_group_id]
      t.index [:event_group_id, :ballot_id]
    end
  end
end
