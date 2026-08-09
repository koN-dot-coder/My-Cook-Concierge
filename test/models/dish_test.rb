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
    assert_equal dish, result
  end
end
