class ChangeEventGroupIdToSectionIdInEvents < ActiveRecord::Migration[5.0]
  def change
    rename_column :events, :event_group_id, :section_id
  end
end
