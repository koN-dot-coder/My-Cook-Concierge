class Dish < ApplicationRecord
  has_many :dish_tags, dependent: :destroy
  has_many :tags, through: :dish_tags
  has_many :histories, dependent: :destroy

  CATEGORY_LABELS = {
    staple: "主食",
    main: "主菜",
    side: "副菜",
    soup: "汁物",
    appetizer: "おつまみ",
    dessert: "お菓子"
  }.freeze

  enum :category, {
    staple: 0,      # 主食
    main: 1,        # 主菜
    side: 2,        # 副菜
    soup: 3,        # 汁物
    appetizer: 4,   # おつまみ
    dessert: 5      # お菓子
  }

  validates :name, presence: true
  validates :category, presence: true

  def category_label
    CATEGORY_LABELS[category.to_sym]
  end

  def self.match_by_tag_names(tag_names)
    names = Array(tag_names).map(&:to_s).uniq
    return random_fallback if names.empty?

    matched = joins(:tags)
              .where(tags: { name: names })
              .group(:id)
              .order(Arel.sql("COUNT(tags.id) DESC"), :id)
              .first

    matched || random_fallback
  end

  def self.random_fallback
    order(Arel.sql("RANDOM()")).first
  end
end
