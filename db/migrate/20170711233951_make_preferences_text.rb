class MakePreferencesText < ActiveRecord::Migration[5.0]
  def change
    change_column :ballots, :preferences, :text
  end
end
