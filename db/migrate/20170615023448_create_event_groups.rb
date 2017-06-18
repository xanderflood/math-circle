class CreateEventGroups < ActiveRecord::Migration[5.0]
  def change
    create_table :event_groups do |t|
      t.string :name
      t.time :when

      t.timestamps
    end
  end
end
