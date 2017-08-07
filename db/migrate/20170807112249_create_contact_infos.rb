class CreateContactInfos < ActiveRecord::Migration[5.0]
  def change
    create_table :contact_infos do |t|
      t.string :email
      t.string :phone

      t.string :street1
      t.string :street2
      t.string :city
      t.string :state
      t.string :zip
    end
  end
end
