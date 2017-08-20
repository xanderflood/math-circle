class AddLotteryStateToSemester < ActiveRecord::Migration[5.0]
  def change
    add_column :semesters, :lottery_open, :boolean
  end
end
