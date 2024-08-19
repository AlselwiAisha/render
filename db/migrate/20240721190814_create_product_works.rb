class CreateProductWorks < ActiveRecord::Migration[7.1]
  def change
    create_table :product_works do |t|
      t.decimal :percent
      t.references :product, foreign_key: {to_table: :products}, null:false
      t.references :work, foreign_key: {to_table: :works}, null:false

      t.timestamps
    end
  end
end
