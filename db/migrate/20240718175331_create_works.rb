class CreateWorks < ActiveRecord::Migration[7.1]
  def change
    create_table :works do |t|
      t.references :shop, null: false, foreign_key: true 
      t.string :name

      t.timestamps
    end
  end
end
