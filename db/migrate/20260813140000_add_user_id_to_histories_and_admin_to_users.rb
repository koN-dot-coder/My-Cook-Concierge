class AddUserIdToHistoriesAndAdminToUsers < ActiveRecord::Migration[8.0]
  def change
    add_reference :histories, :user, foreign_key: true
    add_column :users, :admin, :boolean, null: false, default: false
    add_index :histories, %i[user_id created_at]
  end
end
