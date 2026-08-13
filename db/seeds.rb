# frozen_string_literal: true

puts "Seeding dishes and tags..."

tag_names = %w[
  light fresh hearty comfort indulgent splurge
  quick moderate slow easy nocook cooking
  japanese western asian flexible
  hot cold
  solo family relaxed casual rushed
  healthy rich umami sweet sour creamy
  rice noodles bread
  meat seafood egg_tofu vegetable
  spicy mild
  grilled simmered stir_fried mixed fried
  crispy smooth chewy crunchy
  familiar adventurous
  morning lunch dinner late_night snack
  drink_alcohol drink_tea drink_sweet drink_refreshing
  leftovers bento microwave photogenic energy reward
  budget
].freeze

tag_names.each do |name|
  Tag.find_or_create_by!(name: name)
end

dishes_data = [
  # 主食
  { name: "焼きおにぎり", description: "香ばしくて食べ応えのある一品。", category: :staple, tags: %w[hearty rice japanese quick grilled familiar] },
  { name: "親子丼", description: "卵と鶏肉の定番丼。", category: :staple, tags: %w[hearty rice japanese quick umami comfort familiar] },
  { name: "ナポリタン", description: "ケチャップ味の懐かしい洋食麺。", category: :staple, tags: %w[noodles western moderate familiar] },
  { name: "冷やし中華", description: "夏にぴったりのさっぱり麺。", category: :staple, tags: %w[noodles cold fresh light quick healthy] },
  { name: "ツナマヨおにぎり", description: "手軽に食べられる軽めの主食。", category: :staple, tags: %w[rice japanese easy quick solo light] },

  # 主菜
  { name: "春野菜の彩りパスタ", description: "旬の野菜を使ったさっぱり洋食パスタ。", category: :main, tags: %w[light fresh western quick vegetable photogenic] },
  { name: "かんたんクリーム親子丼", description: "10分で作れる定番の和食メイン。", category: :main, tags: %w[hearty rice japanese quick easy umami] },
  { name: "豚の生姜焼き", description: "ごはんが進む和食の定番主菜。", category: :main, tags: %w[meat japanese umami moderate grilled familiar bento] },
  { name: "鮭のムニエル", description: "バターの香りが食欲をそそる洋食魚料理。", category: :main, tags: %w[seafood western creamy grilled indulgent photogenic] },
  { name: "麻婆豆腐", description: "ごはんに合うピリ辛中華。", category: :main, tags: %w[egg_tofu asian spicy stir_fried hearty rice] },
  { name: "ハンバーグ定食", description: "子どもから大人まで人気の洋食。", category: :main, tags: %w[meat western hearty familiar family grilled] },
  { name: "グリーンカレー", description: "ココナッツの香りが食欲をそそる。", category: :main, tags: %w[asian spicy adventurous rich rice] },

  # 副菜
  { name: "ほうれん草の胡麻和え", description: "さっぱり副菜の定番。", category: :side, tags: %w[vegetable japanese healthy light fresh easy] },
  { name: "ポテトサラダ", description: "洋食の定番サイドディッシュ。", category: :side, tags: %w[western creamy familiar easy cold mixed] },
  { name: "きんぴらごぼう", description: "作り置きにも便利な和の副菜。", category: :side, tags: %w[japanese healthy stir_fried bento familiar budget] },
  { name: "コールスロー", description: "シャキシャキ食感の洋風サラダ。", category: :side, tags: %w[western fresh crunchy vegetable healthy cold] },
  { name: "中華風春雨サラダ", description: "さっぱりとしたエスニック副菜。", category: :side, tags: %w[asian fresh sour vegetable light quick] },

  # 汁物
  { name: "具だくさんミネストローネ", description: "野菜たっぷりの温かいスープ。", category: :soup, tags: %w[hot comfort western moderate vegetable healthy] },
  { name: "味噌汁（豆腐とわかめ）", description: "体が温まる和の定番。", category: :soup, tags: %w[hot japanese umami easy quick comfort familiar] },
  { name: "けんちん汁", description: "根菜たっぷりの優しい味。", category: :soup, tags: %w[hot japanese vegetable healthy simmered comfort] },
  { name: "トマトのポタージュ", description: "酸味とコクのある洋風スープ。", category: :soup, tags: %w[hot western sour creamy smooth photogenic] },
  { name: "酸辣湯", description: "ピリッとした中華スープ。", category: :soup, tags: %w[hot asian spicy sour adventurous] },

  # デザート
  { name: "いちごのパフェ", description: "見た目も華やかな定番デザート。", category: :dessert, tags: %w[sweet indulgent photogenic drink_sweet creamy] },
  { name: "焼きりんご", description: "温かい甘さがほっとする一品。", category: :dessert, tags: %w[sweet comfort hot familiar] },
  { name: "チーズケーキ", description: "コクのある洋風デザート。", category: :dessert, tags: %w[sweet creamy western indulgent photogenic] },
  { name: "抹茶アフォガート", description: "和と洋が融合した大人のデザート。", category: :dessert, tags: %w[sweet japanese indulgent cold photogenic] },
  { name: "フルーツポンチ", description: "さっぱり甘いデザート。", category: :dessert, tags: %w[sweet fresh cold healthy drink_sweet] },

  # お菓子
  { name: "チョコバナナパフェ", description: "甘いものが食べたい夜に。", category: :sweet, tags: %w[sweet snack casual indulgent late_night] },
  { name: "どら焼き", description: "お茶と一緒に楽しむ和菓子。", category: :sweet, tags: %w[sweet japanese familiar drink_tea casual] },
  { name: "クッキー", description: "手軽につまめる焼き菓子。", category: :sweet, tags: %w[sweet easy familiar snack solo] },
  { name: "ベイクドチーズケーキ", description: "しっとり濃厚なお菓子。", category: :sweet, tags: %w[sweet creamy indulgent reward] },
  { name: "わらび餅", description: "きなこと黒蜜の和スイーツ。", category: :sweet, tags: %w[sweet japanese smooth familiar drink_tea] },

  # おつまみ
  { name: "枝豆と冷奴のさっぱりおつまみ", description: "手軽につまめる定番。", category: :appetizer, tags: %w[snack casual light japanese quick nocook healthy drink_alcohol] },
  { name: "チーズとサラミの盛り合わせ", description: "ビールのお供にぴったり。", category: :appetizer, tags: %w[snack casual western drink_alcohol indulgent photogenic] },
  { name: "唐揚げ", description: "ジューシーな定番おつまみ。", category: :appetizer, tags: %w[meat fried crispy casual drink_alcohol hearty familiar] },
  { name: "たこわさ", description: "さっぱりとした和のおつまみ。", category: :appetizer, tags: %w[seafood japanese fresh sour drink_alcohol quick] },
  { name: "フライドポテト", description: "揚げたてのカリッと食感。", category: :appetizer, tags: %w[fried crispy casual snack drink_alcohol western] },

  # ドリンク
  { name: "レモンジンジャーエール", description: "さっぱり爽快なノンアルコール。", category: :drink, tags: %w[drink_refreshing fresh sour cold] },
  { name: "ホットコーヒー", description: "食後にほっと一息。", category: :drink, tags: %w[drink_tea hot comfort relaxed] },
  { name: "抹茶ラテ", description: "和の風味が楽しめるドリンク。", category: :drink, tags: %w[drink_tea japanese sweet relaxed photogenic] },
  { name: "オレンジジュース", description: "甘酸っぱいフルーツドリンク。", category: :drink, tags: %w[drink_sweet fresh morning healthy] },
  { name: "ハイボール（ノンアルコール風）", description: "おつまみと合わせやすい炭酸ドリンク。", category: :drink, tags: %w[drink_alcohol casual drink_refreshing late_night snack] }
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

if Rails.env.development?
  admin = User.find_or_initialize_by(email_address: "admin@example.com")
  if admin.new_record?
    admin.assign_attributes(
      name: "管理者",
      password: "password123",
      password_confirmation: "password123",
      admin: true
    )
    admin.save!
    puts "Created admin user: admin@example.com / password123"
  elsif !admin.admin?
    admin.update!(admin: true)
    puts "Promoted existing admin@example.com to admin"
  end
end
