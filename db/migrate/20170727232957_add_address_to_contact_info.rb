class AddAddressToContactInfo < ActiveRecord::Migration[5.0]
  def change
    remove_column :contact_infos, :street1
    remove_column :contact_infos, :street2
    remove_column :contact_infos, :city
    remove_column :contact_infos, :state
    remove_column :contact_infos, :zipcode
    remove_column :contact_infos, :country
    add_reference :contact_infos, :address, foreign_key: true
  end
end
