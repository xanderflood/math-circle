class RemoveEventDateTimeDefaults < ActiveRecord::Migration[5.0]
  def change
    change_column_default(:events, :when, nil)
    change_column_default(:events, :time, nil)
  end
end
