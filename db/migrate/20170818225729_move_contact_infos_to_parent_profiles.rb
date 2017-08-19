class MoveContactInfosToParentProfiles < ActiveRecord::Migration[5.0]
  def change
    add_column :parent_profiles, :first_name,     :string
    add_column :parent_profiles, :last_name,      :string
    add_column :parent_profiles, :email,          :string
    add_column :parent_profiles, :phone,          :string
    add_column :parent_profiles, :street1,        :string
    add_column :parent_profiles, :street2,        :string
    add_column :parent_profiles, :city,           :string
    add_column :parent_profiles, :state,          :string
    add_column :parent_profiles, :zip,            :string

    add_column :parent_profiles, :ec1_first_name, :string
    add_column :parent_profiles, :ec1_last_name,  :string
    add_column :parent_profiles, :ec1_relation,   :string
    add_column :parent_profiles, :ec1_phone,      :string

    add_column :parent_profiles, :ec2_first_name, :string
    add_column :parent_profiles, :ec2_last_name,  :string
    add_column :parent_profiles, :ec2_relation,   :string
    add_column :parent_profiles, :ec2_phone,      :string

    # migrate data?

    remove_column :parent_profiles, :primary_contact_id, :integer
    remove_column :parent_profiles, :emergency_contact_id, :integer
    remove_column :parent_profiles, :emergency_contact_2_id, :integer
  end
end
