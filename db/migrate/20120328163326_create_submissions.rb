class CreateSubmissions < ActiveRecord::Migration
  def change
    create_table :submissions do |t|
      t.string :author
      t.integer :problem
      t.string :lang
      t.string :verdict
      t.text :code

      t.timestamps
    end
  end
end
