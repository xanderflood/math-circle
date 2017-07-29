class SetDefaultsPriorityForStudents < ActiveRecord::Migration[5.0]
  def change
    Student.where(priority: nil).update_all(priority: 0)

    change_column :students, :priority, :integer, default: 0, null: false
  end
end

