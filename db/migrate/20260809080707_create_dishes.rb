class CreateDishes < ActiveRecord::Migration[8.0]
  def change
    create_table :dishes do |t|
      t.string :name, null: false
      t.text :description
      t.string :image_url
      t.string :recipe_url
      t.integer :category, null: false

      t.timestamps
    end
  end
end
