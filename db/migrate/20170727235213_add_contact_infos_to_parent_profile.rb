class AddContactInfosToParentProfile < ActiveRecord::Migration[5.0]
  def change
    remove_column :parent_profiles, :primary_contact_id
    remove_column :parent_profiles, :energency_contact_id

    add_column    :parent_profiles, :primary_contact_id, :integer
    add_column    :parent_profiles, :emergency_contact_id, :integer
    add_column    :parent_profiles, :emergency_contact_2_id, :integer
  end
end
