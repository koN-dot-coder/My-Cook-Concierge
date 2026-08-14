require "test_helper"

class AccountsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    sign_in_as(@user)
  end

  test "edit requires authentication" do
    delete session_url
    follow_redirect!

    get edit_account_url
    assert_redirected_to new_session_url
  end

  test "edit shows account form" do
    get edit_account_url
    assert_response :success
    assert_match "アカウント設定", response.body
    assert_match @user.email_address, response.body
  end

  test "update changes name" do
    patch account_url, params: { user: { name: "更新後の名前" } }

    assert_redirected_to edit_account_url
    assert_equal "更新後の名前", @user.reload.name
    follow_redirect!
    assert_match "アカウント情報を更新しました", response.body
  end

  test "update changes password" do
    patch account_url, params: {
      user: {
        name: @user.name,
        password: "newpassword123",
        password_confirmation: "newpassword123"
      }
    }

    assert_redirected_to edit_account_url
    assert @user.reload.authenticate("newpassword123")
  end

  test "update rejects invalid password confirmation" do
    patch account_url, params: {
      user: {
        name: @user.name,
        password: "newpassword123",
        password_confirmation: "mismatch123"
      }
    }

    assert_response :unprocessable_entity
    assert_match "アカウント設定", response.body
  end

  test "destroy requires authentication" do
    delete session_url
    follow_redirect!

    delete account_url
    assert_redirected_to new_session_url
  end

  test "destroy deletes user and related data" do
    dish = Dish.create!(name: "退会テスト料理", category: :main)
    @user.favorites.create!(dish: dish)
    @user.histories.create!(dish: dish, course_label: "かんたんコース")
    user_id = @user.id

    delete account_url

    assert_redirected_to root_url
    assert_not User.exists?(user_id)
    assert_equal 0, Favorite.where(user_id: user_id).count
    assert_equal 0, History.where(user_id: user_id).count
    follow_redirect!
    assert_match "アカウントを削除しました", response.body
  end
end
