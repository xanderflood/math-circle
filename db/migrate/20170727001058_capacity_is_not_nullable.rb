class CapacityIsNotNullable < ActiveRecord::Migration[5.0]
  def change
    EventGroup.where(capacity: nil).update_all(capacity: 10)
    change_column :event_groups, :capacity, :integer, null: false
  end
end
