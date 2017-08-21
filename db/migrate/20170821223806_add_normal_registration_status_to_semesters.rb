class AddNormalRegistrationStatusToSemesters < ActiveRecord::Migration[5.0]
  def change
    add_column :semesters, :registration_open, :boolean
  end
end
