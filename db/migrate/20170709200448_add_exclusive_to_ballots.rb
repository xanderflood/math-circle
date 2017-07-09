class AddExclusiveToBallots < ActiveRecord::Migration[5.0]
  def change
    add_column :ballots, :exclusive, :boolean
  end
end
