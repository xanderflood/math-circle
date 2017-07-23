class CreateLotteryErrors < ActiveRecord::Migration[5.0]
  def change
    create_table :lottery_errors do |t|
      t.datetime :timestamp
      t.text :message
      t.text :backtrace

      t.timestamps
    end
  end
end
