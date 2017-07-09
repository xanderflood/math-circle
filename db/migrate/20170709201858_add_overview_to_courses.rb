class AddOverviewToCourses < ActiveRecord::Migration[5.0]
  def change
    add_column :courses, :overview, :string
  end
end
