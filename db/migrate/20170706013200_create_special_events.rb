class CreateSpecialEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :special_events do |t|
      t.string :name
      t.date :date
      t.time :start
      t.time :end
      t.string :description
      t.integer :capacity

      t.timestamps
    end
  end
end
