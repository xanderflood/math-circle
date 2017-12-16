class ChangeParentProfilesStateToInteger < ActiveRecord::Migration[5.0]
  def change
    rename_column :parent_profiles, :state, :state_str
    add_column :parent_profiles, :state, :integer
    execute "UPDATE parent_profiles SET state = state_str::integer"
    remove_column :parent_profiles, :state_str
  end
end
