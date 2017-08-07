class AddInfoToProfiles < ActiveRecord::Migration[5.0]
  def change
    add_column :parent_profiles, :primary_contact_id, :integer
    add_column :parent_profiles, :emergency_contact_id, :integer
    add_column :parent_profiles, :emergency_contact_2_id, :integer
    add_column :parent_profiles, :first_name, :string
    add_column :parent_profiles, :last_name, :string
  end
end
