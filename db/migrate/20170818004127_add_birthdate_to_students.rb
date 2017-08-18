class AddBirthdateToStudents < ActiveRecord::Migration[5.0]
  def change
    add_column :students, :birthdate, :date
  end
end
