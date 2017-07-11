class AddPriorityToStudents < ActiveRecord::Migration[5.0]
  def change
    add_column :students, :priority, :integer
  end
end
