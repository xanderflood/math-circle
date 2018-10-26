class RemoveLevelsFromEventGroups < ActiveRecord::Migration[5.0]
  def change
    remove_column :event_groups, :time, :time
  end
end
