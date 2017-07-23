class CreateLotteries < ActiveRecord::Migration[5.0]
  def change
    create_table :lotteries do |t|
      t.references :semester, foreign_key: true
      t.text :contents

      t.timestamps
    end
  end
end
