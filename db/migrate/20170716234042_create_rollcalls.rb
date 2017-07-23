class CreateRollcalls < ActiveRecord::Migration[5.0]
  def change
    create_table :rollcalls do |t|
      t.references :event, foreign_key: true
      t.text :attendance, default: "{}"
      t.date :date

      t.timestamps
    end
  end
end
