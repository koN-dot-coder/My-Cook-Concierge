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
  { name: "焼きおにぎり", image_key: "yaki-onigiri", description: "香ばしくて食べ応えのある一品。", category: :staple, tags: %w[hearty rice japanese quick grilled familiar] },
  { name: "親子丼", image_key: "oyakodon", description: "卵と鶏肉の定番丼。", category: :staple, tags: %w[hearty rice japanese quick umami comfort familiar] },
  { name: "ナポリタン", image_key: "napolitan", description: "ケチャップ味の懐かしい洋食麺。", category: :staple, tags: %w[noodles western moderate familiar] },
  { name: "冷やし中華", image_key: "hiyashi-chuka", description: "夏にぴったりのさっぱり麺。", category: :staple, tags: %w[noodles cold fresh light quick healthy] },
  { name: "ツナおにぎり", image_key: "tuna-onigiri", description: "手軽に食べられる軽めの主食。", category: :staple, tags: %w[rice japanese easy quick solo light] },
  { name: "カレーライス", image_key: "curry-rice", description: "ごはんにかける定番の一品。", category: :staple, tags: %w[hearty rice japanese moderate umami familiar] },

  # 主菜
  { name: "ミートソースパスタ", image_key: "meat-sauce-pasta", description: "コクのある定番パスタ。", category: :main, tags: %w[hearty western moderate familiar] },
  { name: "ペペロンチーノ", image_key: "peperoncino", description: "ニンニクと唐辛子のパスタ。", category: :main, tags: %w[western moderate spicy familiar] },
  { name: "生姜焼き", image_key: "shogayaki", description: "ごはんが進む和食の定番主菜。", category: :main, tags: %w[meat japanese umami moderate grilled familiar bento] },
  { name: "鮭のムニエル", image_key: "salmon-meuniere", description: "バターの香りが食欲をそそる魚料理。", category: :main, tags: %w[seafood western creamy grilled indulgent photogenic] },
  { name: "麻婆豆腐", image_key: "mapo-tofu", description: "ごはんに合うピリ辛中華。", category: :main, tags: %w[egg_tofu asian spicy stir_fried hearty rice] },
  { name: "ハンバーグ", image_key: "hamburg", description: "子どもから大人まで人気の洋食。", category: :main, tags: %w[meat western hearty familiar family grilled] },
  { name: "グリーンカレー", image_key: "green-curry", description: "ココナッツの香りが食欲をそそる。", category: :main, tags: %w[asian spicy adventurous rich rice] },
  { name: "オムライス", image_key: "omurice", description: "ふわとろ卵の定番洋食。", category: :main, tags: %w[hearty rice western familiar family moderate] },

  # 副菜
  { name: "ほうれん草のおひたし", image_key: "spinach-ohitashi", description: "さっぱり副菜の定番。", category: :side, tags: %w[vegetable japanese healthy light fresh easy] },
  { name: "ポテトサラダ", image_key: "potato-salad", description: "洋食の定番サイドディッシュ。", category: :side, tags: %w[western creamy familiar easy cold mixed] },
  { name: "きんぴらごぼう", image_key: "kinpira-gobo", description: "作り置きにも便利な和の副菜。", category: :side, tags: %w[japanese healthy stir_fried bento familiar budget] },
  { name: "コールスロー", image_key: "coleslaw", description: "シャキシャキ食感の洋風サラダ。", category: :side, tags: %w[western fresh crunchy vegetable healthy cold] },
  { name: "春雨サラダ", image_key: "harusame-salad", description: "さっぱりとしたエスニック副菜。", category: :side, tags: %w[asian fresh sour vegetable light quick] },
  { name: "野菜サラダ", image_key: "vegetable-salad", description: "彩り豊かなシンプルサラダ。", category: :side, tags: %w[western fresh vegetable healthy light easy] },

  # 汁物
  { name: "ミネストローネ", image_key: "minestrone", description: "野菜たっぷりの温かいスープ。", category: :soup, tags: %w[hot comfort western moderate vegetable healthy] },
  { name: "味噌汁", image_key: "miso-soup", description: "体が温まる和の定番。", category: :soup, tags: %w[hot japanese umami easy quick comfort familiar] },
  { name: "けんちん汁", image_key: "kenchin-jiru", description: "根菜たっぷりの優しい味。", category: :soup, tags: %w[hot japanese vegetable healthy simmered comfort] },
  { name: "トマトスープ", image_key: "tomato-soup", description: "酸味とコクのある洋風スープ。", category: :soup, tags: %w[hot western sour creamy smooth photogenic] },
  { name: "酸辣湯", image_key: "sanratan", description: "ピリッとした中華スープ。", category: :soup, tags: %w[hot asian spicy sour adventurous] },
  { name: "コーンスープ", image_key: "corn-soup", description: "甘みのある優しいスープ。", category: :soup, tags: %w[hot western creamy comfort easy] },

  # デザート
  { name: "いちごパフェ", image_key: "strawberry-parfait", description: "見た目も華やかな定番デザート。", category: :dessert, tags: %w[sweet indulgent photogenic drink_sweet creamy] },
  { name: "焼きりんご", image_key: "baked-apple", description: "温かい甘さがほっとする一品。", category: :dessert, tags: %w[sweet comfort hot familiar] },
  { name: "チーズケーキ", image_key: "cheesecake", description: "コクのある洋風デザート。", category: :dessert, tags: %w[sweet creamy western indulgent photogenic] },
  { name: "抹茶アイス", image_key: "matcha-ice", description: "抹茶の風味を楽しむ冷たい甘味。", category: :dessert, tags: %w[sweet japanese indulgent cold photogenic] },
  { name: "フルーツポンチ", image_key: "fruit-punch", description: "さっぱり甘いデザート。", category: :dessert, tags: %w[sweet fresh cold healthy drink_sweet] },
  { name: "プリン", image_key: "pudding", description: "なめらかな定番スイーツ。", category: :dessert, tags: %w[sweet creamy familiar comfort] },

  # お菓子
  { name: "チョコパフェ", image_key: "choco-parfait", description: "甘いものが食べたい夜に。", category: :sweet, tags: %w[sweet snack casual indulgent late_night] },
  { name: "どら焼き", image_key: "dorayaki", description: "お茶と一緒に楽しむ和菓子。", category: :sweet, tags: %w[sweet japanese familiar drink_tea casual] },
  { name: "クッキー", image_key: "cookies", description: "手軽につまめる焼き菓子。", category: :sweet, tags: %w[sweet easy familiar snack solo] },
  { name: "ドーナツ", image_key: "donut", description: "ふんわり甘いおやつ。", category: :sweet, tags: %w[sweet indulgent snack familiar] },
  { name: "わらび餅", image_key: "warabi-mochi", description: "きなこと黒蜜の和スイーツ。", category: :sweet, tags: %w[sweet japanese smooth familiar drink_tea] },
  { name: "ポップコーン", image_key: "popcorn", description: "映画やおやつにぴったり。", category: :sweet, tags: %w[sweet snack casual easy solo] },

  # おつまみ
  { name: "枝豆", image_key: "edamame", description: "手軽につまめる定番。", category: :appetizer, tags: %w[snack casual light japanese quick nocook healthy drink_alcohol] },
  { name: "チーズとサラミ", image_key: "cheese-plate", description: "ビールのお供にぴったり。", category: :appetizer, tags: %w[snack casual western drink_alcohol indulgent photogenic] },
  { name: "唐揚げ", image_key: "karaage", description: "ジューシーな定番おつまみ。", category: :appetizer, tags: %w[meat fried crispy casual drink_alcohol hearty familiar] },
  { name: "たこわさ", image_key: "takowasa", description: "さっぱりとした和のおつまみ。", category: :appetizer, tags: %w[seafood japanese fresh sour drink_alcohol quick] },
  { name: "フライドポテト", image_key: "french-fries", description: "揚げたてのカリッと食感。", category: :appetizer, tags: %w[fried crispy casual snack drink_alcohol western] },
  { name: "ナッツ", image_key: "nuts", description: "香ばしい手軽なおつまみ。", category: :appetizer, tags: %w[snack casual easy drink_alcohol healthy] },

  # ドリンク
  { name: "レモネード", image_key: "lemonade", description: "さっぱり爽快なノンアルコール。", category: :drink, tags: %w[drink_refreshing fresh sour cold] },
  { name: "コーヒー", image_key: "coffee", description: "食後にほっと一息。", category: :drink, tags: %w[drink_tea hot comfort relaxed] },
  { name: "抹茶ラテ", image_key: "matcha-latte", description: "和の風味が楽しめるドリンク。", category: :drink, tags: %w[drink_tea japanese sweet relaxed photogenic] },
  { name: "オレンジジュース", image_key: "orange-juice", description: "甘酸っぱいフルーツドリンク。", category: :drink, tags: %w[drink_sweet fresh morning healthy] },
  { name: "ハイボール", image_key: "highball", description: "おつまみと合わせやすい炭酸ドリンク。", category: :drink, tags: %w[drink_alcohol casual drink_refreshing late_night snack] },
  { name: "ミルクティー", image_key: "milk-tea", description: "まろやかな甘さのティードリンク。", category: :drink, tags: %w[drink_tea sweet relaxed comfort] }
].freeze

new_dish_names = dishes_data.map { |data| data[:name] }
obsolete_dishes = Dish.where.not(name: new_dish_names)
if obsolete_dishes.exists?
  puts "Removing #{obsolete_dishes.count} obsolete dishes..."
  obsolete_dishes.destroy_all
end

dishes_data.each do |data|
  dish = Dish.find_or_initialize_by(name: data[:name])
  dish.assign_attributes(
    description: data[:description],
    category: data[:category],
    image_url: "/images/dishes/#{data[:image_key]}.jpg"
  )
  dish.save!

  data[:tags].each do |tag_name|
    tag = Tag.find_by!(name: tag_name)
    DishTag.find_or_create_by!(dish: dish, tag: tag)
  end
end

puts "Seeded #{Dish.count} dishes, #{Tag.count} tags, #{DishTag.count} dish_tags."

if Rails.env.development?
  admin_email = ENV["DEV_ADMIN_EMAIL"]
  admin_password = ENV["DEV_ADMIN_PASSWORD"]

  if admin_email.blank? || admin_password.blank?
    raise <<~MSG.squish
      開発用管理者アカウントには DEV_ADMIN_EMAIL と DEV_ADMIN_PASSWORD が必要です。
      プロジェクト直下の .env に設定してください（.env.example を参照）。
    MSG
  end

  admin = User.find_or_initialize_by(email_address: admin_email)
  if admin.new_record?
    admin.assign_attributes(
      name: "管理者",
      password: admin_password,
      password_confirmation: admin_password,
      admin: true
    )
    admin.save!
    puts "Created admin user: #{admin_email}"
  elsif !admin.admin?
    admin.update!(admin: true)
    puts "Promoted existing #{admin_email} to admin"
  end
end
