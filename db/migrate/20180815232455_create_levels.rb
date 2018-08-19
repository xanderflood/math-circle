class CreateLevels < ActiveRecord::Migration[5.0]
  def change
    ### setup the new tables ###
    create_table :levels do |t|
      t.string :name
      t.integer :position
      t.integer :max_grade
      t.integer :min_grade
      t.boolean :restricted
      t.boolean :active
    end

    level_ids = {}
    ["unspecified", "A", "B", "C", "D"].each.with_index do |level_name, i|
      level = Level.create!(name: level_name, active: true, position: i, min_grade: 6)
      level_ids[level_name] = level.id
    end

    Level.first(name: "D").update!(min_grade: nil, restricted: true)

    ### migrate existing data ###
    add_reference :courses, :level
    add_reference :students, :level

    Course.all.each do |c|
      #TODO: how to directly reference the old `level` column value?
      c.update!(level_id: level_ids[c[:level].to_s])
    end

    Student.all.each do |s|
      #TODO: how to directly reference the old `level` column value?
      s.update!(level_id: level_ids[s[:level].to_s])
    end

    remove_column :courses, :level, :integer
    remove_column :students, :level, :integer
  end
end
