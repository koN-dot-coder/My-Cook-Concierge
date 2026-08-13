require "test_helper"

class DishesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin = users(:admin)
    @tag_one = Tag.create!(name: "和食タグ")
    @tag_two = Tag.create!(name: "簡単タグ")

    @dish = Dish.create!(
      name: "管理テスト料理",
      description: "テスト用の説明",
      category: :main,
      image_url: "https://example.com/image.jpg",
      recipe_url: "https://example.com/recipe",
      tag_ids: [@tag_one.id]
    )
  end

  test "should get index without authentication" do
    get dishes_url
    assert_response :success
    assert_match "料理一覧", response.body
  end

  test "should get show without authentication" do
    get dish_url(@dish)
    assert_response :success
    assert_match @dish.name, response.body
    assert_match @tag_one.name, response.body
  end

  test "new requires admin" do
    get new_dish_url
    assert_redirected_to new_session_url

    sign_in_as(@admin)
    get new_dish_url
    assert_response :success
  end

  test "non admin cannot create dish" do
    sign_in_as(users(:one))

    assert_no_difference("Dish.count") do
      post dishes_url, params: {
        dish: {
          name: "新規料理",
          description: "新規説明",
          category: "soup",
          tag_ids: [@tag_one.id]
        }
      }
    end

    assert_redirected_to root_path
  end

  test "admin should create dish" do
    sign_in_as(@admin)

    assert_difference("Dish.count", 1) do
      post dishes_url, params: {
        dish: {
          name: "新規料理",
          description: "新規説明",
          category: "soup",
          image_url: "https://example.com/new.jpg",
          recipe_url: "https://example.com/new-recipe",
          tag_ids: [@tag_one.id, @tag_two.id]
        }
      }
    end

    created_dish = Dish.last
    assert_redirected_to dish_url(created_dish)
    assert_equal [@tag_one.id, @tag_two.id].sort, created_dish.tag_ids.sort
    follow_redirect!
    assert_match "料理を登録しました", response.body
  end

  test "admin should get edit" do
    sign_in_as(@admin)
    get edit_dish_url(@dish)
    assert_response :success
    assert_match @tag_one.name, response.body
  end

  test "admin should update dish" do
    sign_in_as(@admin)

    patch dish_url(@dish), params: {
      dish: { name: "更新後の料理名", category: "dessert", tag_ids: [@tag_two.id] }
    }

    assert_redirected_to dish_url(@dish)
    @dish.reload
    assert_equal "更新後の料理名", @dish.name
    assert @dish.dessert?
    assert_equal [@tag_two.id], @dish.tag_ids
  end

  test "admin should destroy dish" do
    sign_in_as(@admin)

    assert_difference("Dish.count", -1) do
      delete dish_url(@dish)
    end

    assert_redirected_to dishes_url
  end
end
