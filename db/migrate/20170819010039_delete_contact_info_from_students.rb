class DeleteContactInfoFromStudents < ActiveRecord::Migration[5.0]
  def change
    remove_column :students, :contact_info_id, :integer
  end
end
