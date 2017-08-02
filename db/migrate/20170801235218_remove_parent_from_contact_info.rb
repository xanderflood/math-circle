class RemoveParentFromContactInfo < ActiveRecord::Migration[5.0]
  def change
    remove_column :contact_infos, :parent_id
  end
end
