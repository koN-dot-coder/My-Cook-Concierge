require "test_helper"

class TagsControllerTest < ActionDispatch::IntegrationTest
  setup do
    DishTag.delete_all
    Tag.delete_all
    @admin = users(:admin)
    @tag = Tag.create!(name: "管理テストタグ")
  end

  test "should get index without authentication" do
    get tags_url
    assert_response :success
    assert_match "管理テストタグ", response.body
  end

  test "should get show without authentication" do
    get tag_url(@tag)
    assert_response :success
    assert_match @tag.name, response.body
  end

  test "new requires admin" do
    get new_tag_url
    assert_redirected_to new_session_url

    sign_in_as(@admin)
    get new_tag_url
    assert_response :success
  end

  test "non admin cannot create tag" do
    sign_in_as(users(:one))

    assert_no_difference("Tag.count") do
      post tags_url, params: { tag: { name: "新規タグ" } }
    end

    assert_redirected_to root_path
  end

  test "admin should create tag" do
    sign_in_as(@admin)

    assert_difference("Tag.count", 1) do
      post tags_url, params: { tag: { name: "新規タグ" } }
    end

    assert_redirected_to tag_url(Tag.last)
    follow_redirect!
    assert_match "タグを登録しました", response.body
  end

  test "admin should get edit" do
    sign_in_as(@admin)
    get edit_tag_url(@tag)
    assert_response :success
  end

  test "admin should update tag" do
    sign_in_as(@admin)

    patch tag_url(@tag), params: { tag: { name: "更新後のタグ名" } }

    assert_redirected_to tag_url(@tag)
    @tag.reload
    assert_equal "更新後のタグ名", @tag.name
  end

  test "admin should destroy tag" do
    sign_in_as(@admin)

    assert_difference("Tag.count", -1) do
      delete tag_url(@tag)
    end

    assert_redirected_to tags_url
  end
end
