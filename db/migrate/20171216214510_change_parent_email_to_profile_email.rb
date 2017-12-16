class ChangeParentEmailToProfileEmail < ActiveRecord::Migration[5.0]
  def change
    execute <<-SQL
UPDATE parents AS p
SET email = pp.email
FROM parent_profiles AS pp
WHERE p.parent_profile_id = pp.id
SQL
  end
end
