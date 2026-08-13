require "test_helper"

class RegistrationsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get new_registration_url
    assert_response :success
    assert_match "新規登録", response.body
  end

  test "should create user and sign in" do
    assert_difference("User.count", 1) do
      post registration_url, params: {
        user: {
          name: "テストユーザー",
          email_address: "test@example.com",
          password: "password123",
          password_confirmation: "password123"
        }
      }
    end

    assert_redirected_to root_url
    follow_redirect!
    assert_match "アカウントを作成しました", response.body
  end

  test "should not create user with invalid data" do
    assert_no_difference("User.count") do
      post registration_url, params: {
        user: {
          name: "",
          email_address: "invalid",
          password: "short",
          password_confirmation: "mismatch"
        }
      }
    end

    assert_response :unprocessable_entity
  end
end
