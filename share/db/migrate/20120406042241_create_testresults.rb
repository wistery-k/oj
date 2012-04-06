class CreateTestresults < ActiveRecord::Migration
  def change
    create_table :testresults do |t|
      t.string :rails
      t.string :g
      t.string :model
      t.string :testresult
      t.string :verdict
      t.text :output
      t.float :cpu
      t.float :memory
      t.integer :testcase_id
      t.references :submission

      t.timestamps
    end
    add_index :testresults, :submission_id
  end
end
