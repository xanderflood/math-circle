class AddStateToSemester < ActiveRecord::Migration[5.0]
  def change
    add_column :semesters, :state, :integer, default: 0
  end
end
