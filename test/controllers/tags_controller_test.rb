require "test_helper"

class TagsControllerTest < ActionDispatch::IntegrationTest
  setup do
    DishTag.delete_all
    Tag.delete_all
    @tag = Tag.create!(name: "管理テストタグ")
  end

  test "should get index" do
    get tags_url
    assert_response :success
    assert_match "管理テストタグ", response.body
  end

  test "should get show" do
    get tag_url(@tag)
    assert_response :success
    assert_match @tag.name, response.body
  end

  test "should get new" do
    get new_tag_url
    assert_response :success
  end

  test "should create tag" do
    assert_difference("Tag.count", 1) do
      post tags_url, params: { tag: { name: "新規タグ" } }
    end

    assert_redirected_to tag_url(Tag.last)
    follow_redirect!
    assert_match "タグを登録しました", response.body
  end

  test "should get edit" do
    get edit_tag_url(@tag)
    assert_response :success
  end

  test "should update tag" do
    patch tag_url(@tag), params: { tag: { name: "更新後のタグ名" } }

    assert_redirected_to tag_url(@tag)
    @tag.reload
    assert_equal "更新後のタグ名", @tag.name
  end

  test "should destroy tag" do
    assert_difference("Tag.count", -1) do
      delete tag_url(@tag)
    end

    assert_redirected_to tags_url
  end
end
