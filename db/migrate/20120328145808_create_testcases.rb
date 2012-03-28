class CreateTestcases < ActiveRecord::Migration
  def change
    create_table :testcases do |t|
      t.text :input
      t.text :output
      t.references :problem

      t.timestamps
    end
    add_index :testcases, :problem_id
  end
end
