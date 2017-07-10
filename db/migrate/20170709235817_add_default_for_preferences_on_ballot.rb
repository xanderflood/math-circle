class AddDefaultForPreferencesOnBallot < ActiveRecord::Migration[5.0]
  def change
    change_column :ballots, :preferences, :string, default: "{}"
  end
end
