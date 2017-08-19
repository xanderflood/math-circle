class RenameGradeOnCourses < ActiveRecord::Migration[5.0]
  def change
    rename_column :courses, :grade, :level
  end
end
