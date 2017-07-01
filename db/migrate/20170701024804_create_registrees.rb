class CreateRegistrees < ActiveRecord::Migration[5.0]
  def change
    create_table :registrees do |t|
      t.references :student, foreign_key: true
      t.references :event_group, foreign_key: true
      t.integer :preference

      t.index [:student_id, :event_group_id]
      t.index [:event_group_id, :student_id]

      t.timestamps
    end
  end
end
