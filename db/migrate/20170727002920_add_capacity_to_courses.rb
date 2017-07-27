class AddCapacityToCourses < ActiveRecord::Migration[5.0]
  def change
    add_column :courses, :capacity, :integer, null: false, default: 10
  end
end
