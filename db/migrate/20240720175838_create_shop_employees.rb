class CreateShopEmployees < ActiveRecord::Migration[7.1]
  def change
    create_table :shop_employees do |t|
      t.references :user, null: false, foreign_key: true
      t.references :shop, null: false, foreign_key: true
      t.integer :role

      t.timestamps
    end
  end
end
