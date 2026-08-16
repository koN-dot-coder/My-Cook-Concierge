require "test_helper"

class RackAttackTest < ActionDispatch::IntegrationTest
  setup do
    Rack::Attack.enabled = true
    Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new
    Rack::Attack.reset!
  end

  teardown do
    Rack::Attack.enabled = false
    Rack::Attack.reset!
  end

  test "throttles repeated login attempts" do
    5.times do
      post session_url, params: { email_address: "nobody@example.com", password: "wrongpassword" }
      assert_not_equal 429, response.status
    end

    post session_url, params: { email_address: "nobody@example.com", password: "wrongpassword" }
    assert_response :too_many_requests
    assert_match "リクエストが多すぎます", response.body
  end

  test "allows user registration" do
    email = "rackattack-#{SecureRandom.hex(4)}@example.com"

    assert_difference("User.count", 1) do
      post registration_url, params: {
        user: {
          name: "レート制限テスト",
          email_address: email,
          password: "password123",
          password_confirmation: "password123"
        }
      }
    end

    assert_redirected_to root_url
  end
end
