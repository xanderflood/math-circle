class NewStateForSemesters < ActiveRecord::Migration[5.0]
  def change
    remove_column :semesters, :current, :boolean
    remove_column :semesters, :state, :integer
    remove_column :semesters, :lottery_open, :boolean
    remove_column :semesters, :registration_open, :boolean

    add_column :semesters, :state, :string
  end
end
