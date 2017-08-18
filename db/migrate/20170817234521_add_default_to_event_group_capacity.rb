class AddDefaultToEventGroupCapacity < ActiveRecord::Migration[5.0]
  def change
    change_column :event_groups, :capacity, :integer, null: false, default: 0
  end
end
