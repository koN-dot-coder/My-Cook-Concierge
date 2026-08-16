class Dish < ApplicationRecord
  has_many :dish_tags, dependent: :destroy
  has_many :tags, through: :dish_tags
  has_many :histories, dependent: :destroy
  has_many :favorites, dependent: :destroy

  CATEGORY_LABELS = {
    staple: "主食",
    main: "主菜",
    side: "副菜",
    soup: "汁物",
    dessert: "デザート",
    sweet: "お菓子",
    appetizer: "おつまみ",
    drink: "ドリンク"
  }.freeze

  CATEGORY_DISPLAY_ORDER = %i[
    staple main side soup dessert sweet appetizer drink
  ].freeze

  enum :category, {
    staple: 0,
    main: 1,
    side: 2,
    soup: 3,
    appetizer: 4,
    dessert: 5,
    sweet: 6,
    drink: 7
  }

  HTTP_URL_FORMAT = URI::DEFAULT_PARSER.make_regexp(%w[http https])

  validates :name, presence: true
  validates :category, presence: true
  validates :image_url, format: { with: HTTP_URL_FORMAT }, allow_blank: true
  validates :recipe_url, format: { with: HTTP_URL_FORMAT }, allow_blank: true

  def category_label
    CATEGORY_LABELS[category.to_sym]
  end

  def self.match_by_tag_names(tag_names, category: nil, limit: 1)
    ranked_matches(tag_names, category: category, limit: limit)
  end

  def self.recommendations_by_category(tag_names, limit_per_category: 3)
    CATEGORY_DISPLAY_ORDER.index_with do |category_key|
      ranked_matches(tag_names, category: category_key, limit: limit_per_category)
    end
  end

  def self.ranked_matches(tag_names, category: nil, limit: 1)
    names = Array(tag_names).map(&:to_s).reject(&:blank?).uniq
    return fallback_for(category, limit) if names.empty?

    scope = joins(:tags).where(tags: { name: names })
    scope = scope.where(category: categories[category]) if category.present?

    dish_ids = scope
               .group("dishes.id")
               .order(Arel.sql("COUNT(tags.id) DESC"), "dishes.id")
               .limit(limit)
               .pluck("dishes.id")

    if dish_ids.any?
      dishes_by_id = includes(:tags).where(id: dish_ids).index_by(&:id)
      dish_ids.filter_map { |id| dishes_by_id[id] }
    else
      fallback_for(category, limit)
    end
  end

  def self.fallback_for(category, limit)
    scope = includes(:tags).order(:id)
    scope = scope.where(category: categories[category]) if category.present?
    scope.limit(limit).to_a
  end
  private_class_method :fallback_for

  def self.random_fallback
    order(Arel.sql("RANDOM()")).first
  end
end
