class RemoveWaitlistsAndRosters < ActiveRecord::Migration[5.0]
  def change 
    remove_column :courses, :waitlist, :text

    remove_column :event_groups, :waitlist, :text
    remove_column :event_groups, :roster, :text
  end
end
