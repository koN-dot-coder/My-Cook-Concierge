class CreateHistories < ActiveRecord::Migration[8.0]
  def change
    create_table :histories do |t|
      t.references :dish, null: false, foreign_key: true

      t.timestamps
    end
  end
end
