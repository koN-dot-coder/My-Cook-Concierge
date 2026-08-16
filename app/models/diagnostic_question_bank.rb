# frozen_string_literal: true

class DiagnosticQuestionBank
  QUESTIONS = [
    {
      id: "mood",
      tier: 1,
      text: "今の気分にいちばん近いのは？",
      hint: "直感で選んでください",
      choices: [
        { key: "refreshed", label: "さっぱり軽め", description: "胃もたれしたくない", tags: %w[light fresh] },
        { key: "satisfied", label: "しっかり満たされたい", description: "ちゃんと食べた感がほしい", tags: %w[hearty rich] },
        { key: "comfort", label: "ほっと落ち着きたい", description: "やさしい味がいい", tags: %w[comfort umami] },
        { key: "indulgent", label: "ちょい贅沢したい", description: "いつもより少し特別感", tags: %w[indulgent splurge creamy] }
      ]
    },
    {
      id: "time",
      tier: 1,
      text: "調理に使える時間は？",
      hint: "今すぐ作る目安で",
      choices: [
        { key: "quick", label: "10分以内", description: "とにかく早く", tags: %w[quick easy] },
        { key: "moderate", label: "20分くらい", description: "手早くでもちゃんと", tags: %w[moderate] },
        { key: "slow", label: "40分以上", description: "じっくり作れる", tags: %w[slow cooking simmered] },
        { key: "nocook", label: "ほぼ作らない", description: "温める・盛るだけ", tags: %w[nocook easy mixed] }
      ]
    },
    {
      id: "genre",
      tier: 1,
      text: "食べたいジャンルは？",
      hint: "いちばん惹かれるものを",
      choices: [
        { key: "japanese", label: "和食", description: "ごはん・味噌汁・定食系", tags: %w[japanese umami] },
        { key: "western", label: "洋食", description: "パスタ・グラタンなど", tags: %w[western creamy] },
        { key: "asian", label: "アジアン", description: "エスニック・スパイシー系", tags: %w[asian spicy] },
        { key: "flexible", label: "ジャンルは問わない", description: "おすすめに任せたい", tags: %w[flexible] }
      ]
    },
    {
      id: "temperature",
      tier: 1,
      text: "食べたい温度感は？",
      hint: "口に入れたときのイメージで",
      choices: [
        { key: "hot", label: "あつあつ", description: "スープ・鍋・焼きたて", tags: %w[hot comfort] },
        { key: "room_temp", label: "ぬるめ〜常温", description: "丼や常温メニュー", tags: %w[moderate] },
        { key: "cold", label: "ひんやり", description: "冷麺・冷製メニュー", tags: %w[cold fresh] },
        { key: "any_temp", label: "どちらでも", description: "おいしければOK", tags: %w[flexible] }
      ]
    },
    {
      id: "volume",
      tier: 1,
      text: "食べたいボリューム感は？",
      hint: "量のイメージで",
      choices: [
        { key: "light_portion", label: "軽め", description: "小腹満たし程度", tags: %w[light casual] },
        { key: "normal_portion", label: "ちょうどいい", description: "普通の一食", tags: %w[moderate] },
        { key: "hearty_portion", label: "がっつり", description: "たくさん食べたい", tags: %w[hearty rich] },
        { key: "any_portion", label: "どちらでも", description: "気にしない", tags: %w[flexible] }
      ]
    },
    {
      id: "effort",
      tier: 1,
      text: "料理の手間はどのくらいならOK？",
      hint: "今日の気力で",
      choices: [
        { key: "easy", label: "超ラク", description: "切る・混ぜる程度", tags: %w[easy quick mixed] },
        { key: "normal_effort", label: "普通", description: "フライパン1つで完結", tags: %w[moderate stir_fried] },
        { key: "cooking", label: "料理したい", description: "ちゃんと作るのが楽しい", tags: %w[cooking slow grilled] },
        { key: "minimal_prep", label: "包丁ほぼ使わない", description: "最小限の下ごしらえ", tags: %w[easy nocook microwave] }
      ]
    },
    {
      id: "spice",
      tier: 1,
      text: "辛さの好みは？",
      hint: "今日の気分で",
      choices: [
        { key: "spicy", label: "辛いの大好き", description: "スパイス効かせたい", tags: %w[spicy asian] },
        { key: "mild_spicy", label: "ほんのり辛い", description: "ピリッとだけ", tags: %w[mild] },
        { key: "no_spicy", label: "辛くない方がいい", description: "マイルドがいい", tags: %w[umami comfort] },
        { key: "any_spice", label: "気にしない", description: "どちらでも", tags: %w[flexible] }
      ]
    },
    {
      id: "scene",
      tier: 1,
      text: "今の食事の雰囲気は？",
      hint: "いまの状況に近いものを",
      choices: [
        { key: "solo", label: "一人でさっと", description: "自分用のごはん", tags: %w[solo quick] },
        { key: "family", label: "家族で囲む", description: "共有して食べる", tags: %w[family hearty] },
        { key: "relaxed", label: "リラックスして", description: "ゆっくり楽しみたい", tags: %w[relaxed comfort casual] },
        { key: "rushed", label: "忙しくて急ぎ", description: "とにかく早く済ませたい", tags: %w[rushed quick easy] }
      ]
    },
    {
      id: "priority",
      tier: 1,
      text: "今日いちばん大事にしたいのは？",
      hint: "ひとつだけ選んでください",
      choices: [
        { key: "priority_speed", label: "とにかく早く", description: "スピード最優先", tags: %w[quick easy rushed] },
        { key: "priority_healthy", label: "体にやさしめ", description: "さっぱり・軽め", tags: %w[healthy light fresh] },
        { key: "priority_volume", label: "満足感", description: "お腹いっぱい", tags: %w[hearty rich] },
        { key: "priority_comfort", label: "癒やされたい", description: "ほっとする味", tags: %w[comfort umami] }
      ]
    },
    {
      id: "richness_overview",
      tier: 1,
      text: "味のイメージは？",
      hint: "全体の味の方向で",
      choices: [
        { key: "light_flavor", label: "さっぱり", description: "油控えめ・軽い", tags: %w[light fresh healthy] },
        { key: "balanced", label: "バランス", description: "どちらでもない", tags: %w[moderate] },
        { key: "rich", label: "こってり", description: "クリーム・脂・コク", tags: %w[rich creamy indulgent] },
        { key: "any_richness", label: "どちらでも", description: "気にしない", tags: %w[flexible] }
      ]
    },
    {
      id: "condition",
      tier: 2,
      text: "今日の体調に近いのは？",
      hint: "無理のない範囲で",
      choices: [
        { key: "energetic", label: "元気いっぱい", description: "なんでもいける", tags: %w[flexible hearty] },
        { key: "tired", label: "ちょっと疲れ気味", description: "消化しやすいものがいい", tags: %w[comfort easy umami] },
        { key: "sensitive_stomach", label: "胃もたれしやすい", description: "あっさりがいい", tags: %w[light healthy fresh] },
        { key: "need_warmth", label: "体を温めたい", description: "温かいものがいい", tags: %w[hot comfort simmered] }
      ]
    },
    {
      id: "flavor_direction",
      tier: 2,
      text: "今ほしい味の方向は？",
      hint: "いちばん惹かれる味で",
      choices: [
        { key: "salty_umami", label: "しょっぱい・うま味", description: "醤油・味噌・だし系", tags: %w[umami japanese] },
        { key: "sweet_flavor", label: "甘い", description: "デザートや甘辛", tags: %w[sweet indulgent] },
        { key: "sour_fresh", label: "酸っぱい・さっぱり", description: "レモン・酢・トマト", tags: %w[sour fresh] },
        { key: "creamy_rich", label: "コク・バター系", description: "濃厚でリッチ", tags: %w[creamy rich western] }
      ]
    },
    {
      id: "staple_type",
      tier: 2,
      text: "主食ならどれが近い？",
      hint: "主食がある場合のイメージで",
      choices: [
        { key: "rice", label: "ごはん", description: "白米・丼・おにぎり", tags: %w[rice japanese] },
        { key: "noodles", label: "麺", description: "パスタ・うどん・ラーメン", tags: %w[noodles] },
        { key: "bread", label: "パン", description: "サンド・トースト系", tags: %w[bread western] },
        { key: "staple_flexible", label: "どれでもおすすめに任せる", description: "こだわりなし", tags: %w[flexible] }
      ]
    },
    {
      id: "protein",
      tier: 2,
      text: "メインの食材はどれがいい？",
      hint: "いちばん食べたいものを",
      choices: [
        { key: "meat", label: "お肉", description: "豚・鶏・牛など", tags: %w[meat hearty] },
        { key: "seafood", label: "お魚・海鮮", description: "さば・鮭・エビなど", tags: %w[seafood healthy] },
        { key: "egg_tofu", label: "卵・豆腐", description: "卵焼き・麻婆豆腐など", tags: %w[egg_tofu japanese] },
        { key: "vegetable_main", label: "野菜中心", description: "野菜が主役", tags: %w[vegetable healthy fresh] }
      ]
    },
    {
      id: "vegetables",
      tier: 2,
      text: "野菜はどのくらい入ってほしい？",
      hint: "今日のバランスで",
      choices: [
        { key: "veggies_heavy", label: "たっぷり", description: "野菜メインでいい", tags: %w[vegetable healthy fresh] },
        { key: "veggies_some", label: "ちょい足し", description: "少しあれば十分", tags: %w[moderate] },
        { key: "veggies_light", label: "あまりいらない", description: "肉や炭水化物中心", tags: %w[meat hearty rich] },
        { key: "veggies_any", label: "気にしない", description: "どちらでも", tags: %w[flexible] }
      ]
    },
    {
      id: "aroma",
      tier: 2,
      text: "惹かれる香りは？",
      hint: "キッチンから漂うイメージで",
      choices: [
        { key: "aroma_japanese", label: "醤油・だし", description: "和の香り", tags: %w[japanese umami] },
        { key: "aroma_western", label: "バター・チーズ", description: "洋の香り", tags: %w[western creamy] },
        { key: "aroma_spice", label: "スパイス・ニンニク", description: "刺激的な香り", tags: %w[spicy asian] },
        { key: "aroma_citrus", label: "柑橘・ハーブ", description: "さわやかな香り", tags: %w[fresh sour] }
      ]
    },
    {
      id: "fridge",
      tier: 2,
      text: "冷蔵庫の食材は？",
      hint: "今あるもので考えて",
      choices: [
        { key: "leftovers", label: "余りものを使いたい", description: "残り物アレンジ向き", tags: %w[leftovers easy quick] },
        { key: "standard_shop", label: "定番を買い足す", description: "スーパーで少し買えばOK", tags: %w[familiar moderate] },
        { key: "minimal_ingredients", label: "最小限の材料", description: "常備食材だけで", tags: %w[easy budget quick] },
        { key: "ingredients_any", label: "気にしない", description: "レシピ優先", tags: %w[flexible] }
      ]
    },
    {
      id: "cleanup",
      tier: 2,
      text: "後片付けの手間は？",
      hint: "洗い物の量で",
      choices: [
        { key: "cleanup_min", label: "最小限にしたい", description: "一品・ワンパン", tags: %w[easy quick mixed] },
        { key: "cleanup_ok", label: "普通ならOK", description: "フライパン＋鍋くらい", tags: %w[moderate] },
        { key: "cleanup_any", label: "気にしない", description: "おいしければ何でも", tags: %w[flexible cooking] },
        { key: "microwave", label: "レンジ中心", description: "レンジ調理がいい", tags: %w[microwave easy quick] }
      ]
    },
    {
      id: "budget",
      tier: 2,
      text: "今日の食費イメージは？",
      hint: "材料費の感覚で",
      choices: [
        { key: "budget_low", label: "節約", description: "安い材料で", tags: %w[budget easy familiar] },
        { key: "budget_normal", label: "普通", description: "いつも通り", tags: %w[moderate] },
        { key: "budget_splurge", label: "ちょい贅沢", description: "いい材料を使いたい", tags: %w[splurge indulgent] },
        { key: "budget_any", label: "気にしない", description: "おいしさ優先", tags: %w[flexible] }
      ]
    },
    {
      id: "familiarity",
      tier: 2,
      text: "今日の料理選びは？",
      hint: "気分の傾向で",
      choices: [
        { key: "familiar", label: "いつもの定番", description: "安心の味がいい", tags: %w[familiar comfort] },
        { key: "somewhat_new", label: "ちょい新しい", description: "普段と違う味", tags: %w[moderate adventurous] },
        { key: "adventurous", label: "初めて挑戦", description: "新レシピにチャレンジ", tags: %w[adventurous spicy] },
        { key: "menu_flexible", label: "おすすめに任せる", description: "どちらでも", tags: %w[flexible] }
      ]
    },
    {
      id: "texture",
      tier: 3,
      text: "食べたい食感は？",
      hint: "口当たりのイメージで",
      choices: [
        { key: "crispy", label: "サクサク・カリッ", description: "揚げ物・焼き目", tags: %w[crispy grilled fried] },
        { key: "smooth", label: "とろとろ・なめらか", description: "シチュー・卵・豆腐", tags: %w[smooth comfort simmered] },
        { key: "chewy", label: "もちもち・噛みごたえ", description: "麺・餅・肉", tags: %w[chewy noodles hearty] },
        { key: "crunchy_veg", label: "シャキシャキ", description: "野菜の歯ごたえ", tags: %w[crunchy fresh vegetable] }
      ]
    },
    {
      id: "cooking_method",
      tier: 3,
      text: "今日の調理スタイルは？",
      hint: "作り方のイメージで",
      choices: [
        { key: "grilled", label: "焼く", description: "フライパン・オーブン", tags: %w[grilled meat] },
        { key: "simmered", label: "煮る", description: "鍋・煮込み", tags: %w[simmered comfort hot] },
        { key: "stir_fried", label: "炒める", description: "中華炒め・パスタ", tags: %w[stir_fried quick moderate] },
        { key: "mixed", label: "混ぜる・盛るだけ", description: "サラダ・丼のせ", tags: %w[mixed easy nocook] }
      ]
    },
    {
      id: "richness_detail",
      tier: 3,
      text: "脂・コクの量は？",
      hint: "こってり感で",
      choices: [
        { key: "low_fat", label: "かなり控えめ", description: "油控えめ・軽い", tags: %w[light healthy fresh] },
        { key: "normal_fat", label: "普通", description: "バランスよく", tags: %w[moderate] },
        { key: "high_fat", label: "しっかりこってり", description: "クリーム・バター・脂", tags: %w[rich creamy indulgent] },
        { key: "fat_any", label: "気にしない", description: "どちらでも", tags: %w[flexible] }
      ]
    },
    {
      id: "time_of_day",
      tier: 3,
      text: "今の食事はどの時間帯っぽい？",
      hint: "ライフスタイルで",
      choices: [
        { key: "morning", label: "朝・ブランチ", description: "軽め〜しっかり朝食", tags: %w[morning light bread] },
        { key: "lunch", label: "昼", description: "ランチ・定食", tags: %w[lunch moderate] },
        { key: "dinner", label: "夜のごはん", description: "夕食・メイン", tags: %w[dinner hearty] },
        { key: "late_night", label: "夜食・深夜", description: "軽い一品", tags: %w[late_night casual snack] }
      ]
    },
    {
      id: "drink_pairing",
      tier: 3,
      text: "一緒に楽しむ飲み物のイメージは？",
      hint: "ドリンク欄の提案に使います",
      choices: [
        { key: "drink_alcohol", label: "ビール・お酒向き", description: "つまみと一緒に", tags: %w[drink_alcohol casual appetizer] },
        { key: "drink_tea_coffee", label: "お茶・コーヒー向き", description: "軽めの食事と", tags: %w[drink_tea light sweet] },
        { key: "drink_sweet", label: "ジュース・甘い飲み物", description: "デザート寄り", tags: %w[drink_sweet sweet indulgent] },
        { key: "drink_refreshing", label: "さっぱり系の飲み物", description: "炭酸水・レモン水等", tags: %w[drink_refreshing fresh sour] }
      ]
    },
    {
      id: "nostalgia",
      tier: 3,
      text: "味の「懐かしさ」は？",
      hint: "思い出の味で",
      choices: [
        { key: "nostalgic_child", label: "幼少期の味", description: "おふくろの味・家庭料理", tags: %w[familiar japanese comfort] },
        { key: "nostalgic_student", label: "学生時代の味", description: "ラーメン・カレー・丼", tags: %w[familiar hearty noodles] },
        { key: "not_nostalgic", label: "新しい味がいい", description: "懐かしさは不要", tags: %w[adventurous asian] },
        { key: "nostalgia_any", label: "どちらでも", description: "おいしければ", tags: %w[flexible] }
      ]
    },
    {
      id: "meal_prep",
      tier: 3,
      text: "作ったあとどうする？",
      hint: "食べ方の予定で",
      choices: [
        { key: "eat_now", label: "その場で全部食べる", description: "作りたて一食", tags: %w[hot grilled] },
        { key: "bento", label: "明日の弁当にも", description: "作り置き向き", tags: %w[bento familiar moderate] },
        { key: "leftover_ok", label: "余ってもアレンジ", description: "残り物活用", tags: %w[leftovers easy] },
        { key: "storage_any", label: "気にしない", description: "特に予定なし", tags: %w[flexible] }
      ]
    },
    {
      id: "stress_food",
      tier: 3,
      text: "今日、食事に求めることは？",
      hint: "心の状態で",
      choices: [
        { key: "heal", label: "癒やし", description: "ほっと一息", tags: %w[comfort umami hot] },
        { key: "refresh_mind", label: "リフレッシュ", description: "さっぱり切り替え", tags: %w[fresh sour light] },
        { key: "energy", label: "エネルギー補給", description: "パワーをもらう", tags: %w[hearty rice energy] },
        { key: "reward", label: "ご褒美", description: "自分へのごほうび", tags: %w[indulgent sweet splurge] }
      ]
    },
    {
      id: "presentation",
      tier: 3,
      text: "見た目のこだわりは？",
      hint: "盛り付けのイメージで",
      choices: [
        { key: "simple_look", label: "シンプルでいい", description: "味が大事", tags: %w[familiar easy] },
        { key: "slightly_fancy", label: "ちょっと華やか", description: "見た目も楽しみたい", tags: %w[moderate photogenic] },
        { key: "photogenic", label: "映えも大事", description: "写真にも残したい", tags: %w[photogenic indulgent] },
        { key: "look_any", label: "気にしない", description: "どちらでも", tags: %w[flexible] }
      ]
    },
    {
      id: "final_taste",
      tier: 3,
      text: "最後に、今いちばん欲しい味は？",
      hint: "直感でひとつだけ",
      choices: [
        { key: "umami_final", label: "出汁・醤油のうま味", description: "和の基本", tags: %w[umami japanese] },
        { key: "sour_final", label: "トマト・酢の酸味", description: "さっぱり刺激", tags: %w[sour fresh] },
        { key: "rich_final", label: "バター・チーズのコク", description: "濃厚な味", tags: %w[creamy rich western] },
        { key: "sweet_final", label: "甘み・蜂蜜系", description: "甘い余韻", tags: %w[sweet indulgent] }
      ]
    }
  ].freeze

  class << self
    def all
      QUESTIONS
    end

    def find(id)
      QUESTIONS.find { |question| question[:id] == id }
    end

    def questions_for_count(count)
      max_tier = case count
                 when 10 then 1
                 when 20 then 2
                 when 30 then 3
                 else 1
                 end

      questions_for_tiers(1..max_tier)
    end

    def questions_for_tiers(tier_range)
      tier_set = tier_range.to_set
      tier_one = QUESTIONS.select { |question| question[:tier] == 1 && tier_set.include?(1) }
      tier_two = QUESTIONS.select { |question| question[:tier] == 2 && tier_set.include?(2) }.shuffle
      tier_three = QUESTIONS.select { |question| question[:tier] == 3 && tier_set.include?(3) }.shuffle

      tier_one + tier_two + tier_three
    end

    def build_question_order(count)
      questions_for_count(count).map { |question| question[:id] }
    end

    def choice_tags(question_id, choice_key)
      question = find(question_id)
      return [] unless question

      choice = question[:choices].find { |item| item[:key] == choice_key }
      choice ? choice[:tags] : []
    end

    def collected_tags_from_answers(answers)
      Array(answers).flat_map { |answer| tags_for_answer(answer) }.uniq
    end

    def tags_for_answer(answer)
      return Array(answer["tags"]) if answer["tags"].present?

      choice_tags(answer["q"] || answer["question_id"], answer["c"] || answer["choice_key"])
    end
  end
end
