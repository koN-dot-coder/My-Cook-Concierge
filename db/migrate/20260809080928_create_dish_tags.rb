class CreateDishTags < ActiveRecord::Migration[8.0]
  def change
    create_table :dish_tags do |t|
      t.references :dish, null: false, foreign_key: true
      t.references :tag, null: false, foreign_key: true

      t.timestamps
    end

    add_index :dish_tags, [:dish_id, :tag_id], unique: true
  end
end
