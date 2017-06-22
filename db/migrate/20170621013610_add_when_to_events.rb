class AddWhenToEvents < ActiveRecord::Migration[5.0]
  def change
    add_column :events, :when, :date, default: Date.today
  end
end
