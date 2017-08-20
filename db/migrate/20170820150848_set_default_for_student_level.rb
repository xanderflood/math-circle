class SetDefaultForStudentLevel < ActiveRecord::Migration[5.0]
  def change
    change_column :students, :level, :integer, null: false, default: 0
  end
end
