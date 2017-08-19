class DropContactInfos < ActiveRecord::Migration[5.0]
  def change
    drop_table :contact_infos
  end
end
