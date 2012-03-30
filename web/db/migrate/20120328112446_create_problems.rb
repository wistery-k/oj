class CreateProblems < ActiveRecord::Migration
  def change
    create_table :problems do |t|
      t.string :title
      t.text :statement
      t.float :time_limit
      t.float :memory_limit

      t.timestamps
    end
  end
end
