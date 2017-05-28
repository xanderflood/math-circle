class AddParentProfileToParents < ActiveRecord::Migration[5.0]
  def change
    add_reference :parents, :parent_profile, foreign_key: true
  end
end
