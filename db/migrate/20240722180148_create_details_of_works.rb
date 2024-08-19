class CreateDetailsOfWorks < ActiveRecord::Migration[7.1]
  def change
    create_table :details_of_works do |t|
      t.references :shop_employee, null: false, foreign_key: true
      t.references :product_work, null: false, foreign_key: true
      t.decimal :price
      t.integer :count, default: 1
      t.integer :percent_done, default: 1
      t.datetime :start_date, null: false

      t.timestamps
    end
  end
end
