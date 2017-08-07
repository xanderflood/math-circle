class CreateContactInfos < ActiveRecord::Migration[5.0]
  def change
    create_table :contact_infos do |t|
      t.string :email
      t.string :phone
      t.address :address
    end
  end
end
