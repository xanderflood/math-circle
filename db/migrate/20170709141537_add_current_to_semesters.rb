class AddCurrentToSemesters < ActiveRecord::Migration[5.0]
  def change
    add_column :semesters, :current, :boolean, default: false
  end
end
