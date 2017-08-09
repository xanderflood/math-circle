class AddWaiverToStudents < ActiveRecord::Migration[5.0]
  def change
    add_column :students, :photo_permission, :boolean, null: false, default: false
    add_column :students, :waiver,           :boolean, null: false, default: false
  end
end
