class AddWaitlistToCourse < ActiveRecord::Migration[5.0]
  def change
    add_column :courses, :waitlist, :text
  end
end
