class CreateRegistrees < ActiveRecord::Migration[5.0]
  def change
    create_table :registrees do |t|
      t.references :semester, foreign_key: true, null: false
      t.references :student,  foreign_key: true, null: false
      t.references :course,   foreign_key: true, null: false
      t.references :section,  references: :event_group
      t.text :preferences

      t.timestamps
    end
  end
end
