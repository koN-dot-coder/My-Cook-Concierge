require "test_helper"

class HistoryTest < ActiveSupport::TestCase
  setup do
    Rails.application.load_seed if Dish.none?
    @dish = Dish.find_by!(name: "かんたんクリーム親子丼")
    @staple = Dish.find_by!(name: "親子丼")
  end

  test "belongs to dish" do
    history = History.create!(dish: @dish)
    assert_equal @dish, history.dish
  end

  test "requires dish" do
    history = History.new
    assert_not history.valid?
  end

  test "recommendations_by_category restores saved dishes" do
    history = History.create!(
      dish: @dish,
      course_label: "かんたんコース",
      question_count: 10,
      collected_tags: %w[japanese umami],
      recommendations: {
        "main" => [@dish.id],
        "staple" => [@staple.id]
      }
    )

    recommendations = history.recommendations_by_category

    assert_equal [@dish], recommendations[:main]
    assert_equal [@staple], recommendations[:staple]
  end

  test "legacy history falls back to featured dish only" do
    history = History.create!(dish: @dish)

    recommendations = history.recommendations_by_category

    assert_equal [@dish], recommendations[:main]
    assert_empty recommendations[:staple]
  end
end
