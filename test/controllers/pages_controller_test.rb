require "test_helper"

class PagesControllerTest < ActionDispatch::IntegrationTest
  test "should get terms" do
    get terms_url
    assert_response :success
    assert_match "利用規約", response.body
  end

  test "should get privacy" do
    get privacy_url
    assert_response :success
    assert_match "プライバシーポリシー", response.body
  end
end
