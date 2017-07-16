class AddCapacityToEventGroups < ActiveRecord::Migration[5.0]
  def change
    add_column :event_groups, :capacity, :integer
  end
end
