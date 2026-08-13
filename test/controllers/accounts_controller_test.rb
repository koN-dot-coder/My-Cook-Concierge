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
end
