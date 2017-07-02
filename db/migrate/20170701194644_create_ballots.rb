class CreateBallots < ActiveRecord::Migration[5.0]
  def change
    create_table :ballots do |t|
      t.references :student, foreign_key: true
      t.references :semester, foreign_key: true
      t.references :course, foreign_key: true
    end
  end
end
