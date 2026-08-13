require "test_helper"

class FavoriteTest < ActiveSupport::TestCase
  setup do
    @user = User.create!(
      name: "テストユーザー",
      email_address: "favorite-model@example.com",
      password: "password123",
      password_confirmation: "password123"
    )
    @dish = Dish.create!(name: "テスト料理", category: :main)
  end

  test "valid favorite" do
    favorite = Favorite.new(user: @user, dish: @dish)
    assert favorite.valid?
    assert favorite.save
  end

  test "requires unique dish per user" do
    Favorite.create!(user: @user, dish: @dish)
    duplicate = Favorite.new(user: @user, dish: @dish)

    assert_not duplicate.valid?
    assert_includes duplicate.errors[:dish_id], "はすでに存在します"
  end
end
