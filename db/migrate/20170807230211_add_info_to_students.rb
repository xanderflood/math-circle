class AddInfoToStudents < ActiveRecord::Migration[5.0]
  def change
    add_reference :students, :contact_info, foreign_key: true
    add_column :students, :school, :string
    add_column :students, :school_grade, :integer
    add_column :students, :highest_math_class, :string
  end
end
