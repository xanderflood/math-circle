class AddWaitlistAndRosterToEventGroups < ActiveRecord::Migration[5.0]
  def change
    add_column :event_groups, :waitlist, :text, default: "[]"
    add_column :event_groups, :roster, :text, default: "[]"
  end
end
