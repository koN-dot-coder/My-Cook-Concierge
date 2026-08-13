require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(
      name: "ログインテスト",
      email_address: "login@example.com",
      password: "password123",
      password_confirmation: "password123"
    )
  end

  test "should get new" do
    get new_session_url
    assert_response :success
    assert_match "ログイン", response.body
  end

  test "should sign in" do
    post session_url, params: { email_address: @user.email_address, password: "password123" }
    assert_redirected_to root_url
    follow_redirect!
    assert_match "ログインしました", response.body
  end

  test "should reject invalid credentials" do
    post session_url, params: { email_address: @user.email_address, password: "wrong" }
    assert_redirected_to new_session_url
    follow_redirect!
    assert_match "メールアドレスまたはパスワードが正しくありません", response.body
  end

  test "should sign out" do
    post session_url, params: { email_address: @user.email_address, password: "password123" }
    delete session_url
    assert_redirected_to session_complete_url
  end

  test "should get logout complete page" do
    get session_complete_url
    assert_response :success
    assert_match "ご利用ありがとうございました", response.body
  end
end
