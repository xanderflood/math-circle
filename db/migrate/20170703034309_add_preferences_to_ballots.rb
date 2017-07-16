class AddPreferencesToBallots < ActiveRecord::Migration[5.0]
  def change
    add_column :ballots, :preferences, :text
  end
end
