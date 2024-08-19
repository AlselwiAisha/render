class CreateProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :products do |t|
      t.string :name
      t.references :prototype, foreign_key: { to_table: :prototypes }, null: false
      t.references :shop, foreign_key: { to_table: :shops }, null: false
      t.decimal :price

      t.timestamps
    end
  end
end
