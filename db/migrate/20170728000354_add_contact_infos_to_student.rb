class AddContactInfosToStudent < ActiveRecord::Migration[5.0]
  def change
    remove_column :students, :contact_info_id

    add_column :students, :emergency_contact_id, :integer
    add_column :students, :emergency_contact_2_id, :integer
  end
end
