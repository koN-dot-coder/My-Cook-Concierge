class History < ApplicationRecord
  belongs_to :dish
  belongs_to :user, optional: true

  validates :dish, presence: true

  def recommendations_by_category
    return legacy_recommendations_by_category if recommendations.blank?

    dishes_by_id = Dish.includes(:tags).where(id: all_recommended_dish_ids).index_by(&:id)

    Dish::CATEGORY_DISPLAY_ORDER.index_with do |category_key|
      Array(recommendations[category_key.to_s]).filter_map { |dish_id| dishes_by_id[dish_id] }
    end
  end

  private

  def all_recommended_dish_ids
    recommendations.values.flatten.compact.uniq
  end

  def legacy_recommendations_by_category
    Dish::CATEGORY_DISPLAY_ORDER.index_with { [] }.tap do |categories|
      categories[:main] = [dish] if dish
    end
  end
end
