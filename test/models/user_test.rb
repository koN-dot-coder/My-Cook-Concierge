require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "valid user" do
    user = User.new(
      name: "テストユーザー",
      email_address: "test@example.com",
      password: "password123",
      password_confirmation: "password123"
    )

    assert user.valid?
  end

  test "rejects invalid email format" do
    user = User.new(
      name: "テストユーザー",
      email_address: "invalid-email",
      password: "password123",
      password_confirmation: "password123"
    )

    assert_not user.valid?
    assert_includes user.errors[:email_address], "の形式が正しくありません"
  end

  test "rejects short password" do
    user = User.new(
      name: "テストユーザー",
      email_address: "test@example.com",
      password: "short",
      password_confirmation: "short"
    )

    assert_not user.valid?
    assert_includes user.errors[:password], "は8文字以上で入力してください"
  end

  test "rejects mismatched password confirmation" do
    user = User.new(
      name: "テストユーザー",
      email_address: "test@example.com",
      password: "password123",
      password_confirmation: "different123"
    )

    assert_not user.valid?
    assert_includes user.errors[:password_confirmation], "と一致しません"
  end

  test "normalizes email address" do
    user = User.create!(
      name: "テストユーザー",
      email_address: "  Test@Example.COM ",
      password: "password123",
      password_confirmation: "password123"
    )

    assert_equal "test@example.com", user.email_address
  end
end
