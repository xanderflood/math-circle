class ChangeWaiverFieldsForStudents < ActiveRecord::Migration[5.0]
  def change
    add_column :students, :waiver_submitted, :boolean, default: false
    add_column :students, :waiver_confirmed, :boolean, default: false

    remove_column :students, :waiver, :boolean
    remove_column :students, :photo_permission, :boolean
  end
end
