class AddIdToBallotsEventGroups < ActiveRecord::Migration[5.0]
  def change
    add_column :ballots_event_groups, :id, :primary_keyr
  end
end
