class CreateLevels < ActiveRecord::Migration[5.0]
  def change
    ### setup the new tables ###
    create_table :levels do |t|
      t.string :name,      unique: true
      t.integer :position, unique: true,              null: false
      t.integer :max_grade,              default: 1,  null: false
      t.integer :min_grade,              default: 12, null: false
      t.boolean :restricted
      t.boolean :active,                 default: true
    end

    level_ids = {}
    ["A", "B", "C", "D"].each.with_index do |level_name, i|
      level = Level.create!(
        name: level_name,
        active: true,
        position: i+1,
        min_grade: 6,
        max_grade: 12)
      level_ids[level_name] = level.id
    end

    Level.where(name: "D").first.update!(restricted: true)

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
