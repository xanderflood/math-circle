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

    # create the placeholder levels
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
    level_ids['unspecified'] = nil

    fail unless Level.where(name: "D").first.update_column(:restricted, true)

    # migrate existing data
    add_reference :courses, :level, null: false, default: level_ids["A"]
    add_reference :students, :level

    translation = ["unspecified", "A", "B", "C", "D"]
    Course.all.each do |c|
      fail unless c.update_column(:level_id, level_ids[translation[c[:level]]])
    end

    Student.all.each do |s|
      fail unless s.update_column(:level_id, level_ids[translation[s[:level]]])
    end

    remove_column :courses, :level, :integer
    remove_column :students, :level, :integer
  end
end
