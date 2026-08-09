# frozen_string_literal: true

puts "Seeding dishes and tags..."

TAG_NAMES = %w[
  light fresh quick hearty rice snack casual hot comfort
  easy moderate slow cooking nocook japanese western asian spicy flexible
].freeze

TAG_NAMES.each do |name|
  Tag.find_or_create_by!(name: name)
end

dishes_data = [
  {
    name: "春野菜の彩りパスタ",
    description: "旬の野菜を使ったさっぱり洋食パスタ。",
    category: :main,
    tags: %w[light fresh western quick]
  },
  {
    name: "かんたんクリーム親子丼",
    description: "10分で作れる定番の和食メイン。",
    category: :main,
    tags: %w[hearty rice japanese quick easy]
  },
  {
    name: "具だくさんミネストローネ",
    description: "野菜たっぷりの温かいスープ。",
    category: :soup,
    tags: %w[hot comfort western moderate]
  },
  {
    name: "枝豆と冷奴のさっぱりおつまみ",
    description: "手軽につまめる定番おつまみ。",
    category: :appetizer,
    tags: %w[snack casual light japanese quick nocook]
  },
  {
    name: "焼きおにぎり",
    description: "香ばしくて食べ応えのある主食。",
    category: :staple,
    tags: %w[hearty rice japanese quick]
  },
  {
    name: "チョコバナナパフェ",
    description: "甘いものが食べたい夜に。",
    category: :dessert,
    tags: %w[snack casual flexible]
  }
].freeze

dishes_data.each do |data|
  dish = Dish.find_or_initialize_by(name: data[:name])
  dish.assign_attributes(
    description: data[:description],
    category: data[:category]
  )
  dish.save!

  data[:tags].each do |tag_name|
    tag = Tag.find_by!(name: tag_name)
    DishTag.find_or_create_by!(dish: dish, tag: tag)
  end
end

puts "Seeded #{Dish.count} dishes, #{Tag.count} tags, #{DishTag.count} dish_tags."
