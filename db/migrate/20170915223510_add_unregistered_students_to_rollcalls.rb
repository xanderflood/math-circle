class AddUnregisteredStudentsToRollcalls < ActiveRecord::Migration[5.0]
  def change
    add_column :rollcalls, :unregistered_students, :text, default: "[]"
  end
end
