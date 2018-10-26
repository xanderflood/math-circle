class EventDateTimeNotNullable < ActiveRecord::Migration[5.0]
  def change
    change_column :events, :when, :date, null: false
    change_column :events, :time, :time, null: false
  end
end
