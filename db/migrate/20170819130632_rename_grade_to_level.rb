class RenameGradeToLevel < ActiveRecord::Migration[5.0]
  def change
    rename_column :students, :grade, :level
  end
end
