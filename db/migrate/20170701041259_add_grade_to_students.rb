class AddGradeToStudents < ActiveRecord::Migration[5.0]
  def change
    add_column :students, :grade, :integer
  end
end
