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

    # bypass lots of ActiveRecords hooks
    Level.after_save.clear
    Level.after_create.clear
    Level.after_update.clear
    Level.before_update.clear
    Course.after_update.clear
    Course.before_update.clear
    Student.after_update.clear
    Student.before_update.clear

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

    Level.where(name: "D").first.update!(restricted: true)

    # migrate existing data
    add_reference :courses, :level, null: false, default: level_ids["A"]
    add_reference :students, :level

    translation = ["unspecified", "A", "B", "C", "D"]
    Course.all.each do |c|
      c[:level_id] = level_ids[translation[c[:level]]]
      c.save(validate: false)
    end

    Student.all.each do |s|
      s[:level_id] = level_ids[translation[c[:level]]]
      s.save(validate: false)
    end

    remove_column :courses, :level, :integer
    remove_column :students, :level, :integer
  end
end
