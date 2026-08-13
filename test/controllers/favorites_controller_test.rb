require "test_helper"

class FavoritesControllerTest < ActionDispatch::IntegrationTest
  setup do
    Rails.application.load_seed if Dish.none?

    @user = User.create!(
      name: "お気に入りテスト",
      email_address: "favorites@example.com",
      password: "password123",
      password_confirmation: "password123"
    )
    @dish = Dish.first
  end

  test "index requires authentication" do
    get favorites_url
    assert_redirected_to new_session_url
  end

  test "index shows favorites for signed in user" do
    sign_in_as(@user)
    Favorite.create!(user: @user, dish: @dish)

    get favorites_url
    assert_response :success
    assert_match "お気に入り", response.body
    assert_match @dish.name, response.body
  end

  test "index shows empty state" do
    sign_in_as(@user)

    get favorites_url
    assert_response :success
    assert_match "まだお気に入りがありません", response.body
  end

  test "create adds favorite" do
    sign_in_as(@user)

    assert_difference("Favorite.count", 1) do
      post favorite_dish_url(@dish)
    end

    assert_redirected_to favorites_url
    follow_redirect!
    assert_match "お気に入りに追加しました", response.body
  end

  test "create does not duplicate favorite" do
    sign_in_as(@user)
    Favorite.create!(user: @user, dish: @dish)

    assert_no_difference("Favorite.count") do
      post favorite_dish_url(@dish)
    end

    assert_redirected_to favorites_url
  end

  test "destroy removes favorite" do
    sign_in_as(@user)
    Favorite.create!(user: @user, dish: @dish)

    assert_difference("Favorite.count", -1) do
      delete favorite_dish_url(@dish)
    end

    assert_redirected_to favorites_url
    follow_redirect!
    assert_match "お気に入りから削除しました", response.body
  end

  test "create requires authentication" do
    post favorite_dish_url(@dish)
    assert_redirected_to new_session_url
  end

  private

  def sign_in_as(user)
    super(user, password: "password123")
  end
end
