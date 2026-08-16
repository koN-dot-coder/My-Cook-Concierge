require "test_helper"

class DishTest < ActiveSupport::TestCase
  test "valid dish with category enum" do
    dish = Dish.new(name: "テスト料理", category: :main)
    assert dish.valid?
    assert dish.main?
    assert_equal "主菜", dish.category_label
  end

  test "requires name and category" do
    dish = Dish.new
    assert_not dish.valid?
    assert_includes dish.errors[:name], "を入力してください"
    assert_includes dish.errors[:category], "を入力してください"
    assert_includes dish.errors.full_messages, "料理名を入力してください"
    assert_includes dish.errors.full_messages, "カテゴリを入力してください"
  end

  test "rejects invalid image_url format" do
    dish = Dish.new(name: "URLテスト", category: :main, image_url: "not-a-url")

    assert_not dish.valid?
    assert_includes dish.errors[:image_url], "の形式が正しくありません"
  end

  test "allows blank image_url and recipe_url" do
    dish = Dish.new(name: "URLテスト", category: :main)

    assert dish.valid?
  end

  test "accepts http and https urls" do
    dish = Dish.new(
      name: "URLテスト",
      category: :main,
      image_url: "https://example.com/image.jpg",
      recipe_url: "http://example.com/recipe"
    )

    assert dish.valid?
  end

  test "match_by_tag_names returns dish with most matching tags" do
    dish = Dish.create!(name: "マッチテスト", category: :main)
    quick_tag = Tag.create!(name: "match_quick_#{SecureRandom.hex(4)}")
    japanese_tag = Tag.create!(name: "match_japanese_#{SecureRandom.hex(4)}")
    other_tag = Tag.create!(name: "match_other_#{SecureRandom.hex(4)}")

    DishTag.create!(dish: dish, tag: quick_tag)
    DishTag.create!(dish: dish, tag: japanese_tag)

    other_dish = Dish.create!(name: "別料理", category: :soup)
    DishTag.create!(dish: other_dish, tag: quick_tag)

    result = Dish.match_by_tag_names([quick_tag.name, japanese_tag.name, other_tag.name])
    assert_equal dish, result.first
  end

  test "recommendations_by_category returns dishes per category" do
    Rails.application.load_seed if Dish.none?

    recommendations = Dish.recommendations_by_category(%w[japanese umami quick])
    assert recommendations[:main].any?
    assert recommendations[:staple].any?
    assert recommendations[:drink].any?
  end

  test "category labels include eight display categories" do
    assert_equal 8, Dish::CATEGORY_DISPLAY_ORDER.size
    assert_equal "デザート", Dish::CATEGORY_LABELS[:dessert]
    assert_equal "お菓子", Dish::CATEGORY_LABELS[:sweet]
    assert_equal "ドリンク", Dish::CATEGORY_LABELS[:drink]
  end
end
