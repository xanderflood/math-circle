class MoveParentNameToContactInfo < ActiveRecord::Migration[5.0]
  def change
    remove_column :parent_profiles, :first_name, :string
    remove_column :parent_profiles, :last_name, :string
    add_column :contact_infos, :first_name, :string
    add_column :contact_infos, :last_name, :string
  end
end
