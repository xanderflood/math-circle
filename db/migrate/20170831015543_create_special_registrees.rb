class CreateSpecialRegistrees < ActiveRecord::Migration[5.0]
  def change
    create_table :special_registrees do |t|
      t.references :parent, foreign_key: true, null: false
      t.references :special_event, foreign_key: true, null: false
      t.integer :value, null: false

      t.timestamps
    end
  end
end
