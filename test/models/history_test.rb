require "test_helper"

class HistoryTest < ActiveSupport::TestCase
  setup do
    @dish = Dish.create!(name: "テスト料理", category: :main)
  end

  test "belongs to dish" do
    history = History.create!(dish: @dish)
    assert_equal @dish, history.dish
  end

  test "requires dish" do
    history = History.new
    assert_not history.valid?
  end
end
