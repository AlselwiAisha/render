class CreateShops < ActiveRecord::Migration[7.1]
  def change
    create_table :shops do |t|
      t.string :name
      t.string :phone
      t.string :location
      t.string :website

      t.timestamps
    end
  end
end
