class AddWeekdayAndTimeToEventGroups < ActiveRecord::Migration[5.0]
  def change
    remove_columns :event_groups, :when
    add_column :event_groups, :wday, :integer
    add_column :event_groups, :time, :time
  end
end
