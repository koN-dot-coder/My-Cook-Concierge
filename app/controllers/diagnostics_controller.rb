class DiagnosticsController < ApplicationController
  ALLOWED_QUESTION_COUNTS = [10, 20, 30].freeze

  COURSE_LABELS = {
    10 => "かんたんコース",
    20 => "ふつうコース",
    30 => "じっくりコース"
  }.freeze

  MOCK_QUESTIONS = [
    {
      id: "mood",
      text: "今の気分に近いのはどれ？",
      hint: "直感でいちばん近いものを選んでください",
      choices: [
        { key: "light", label: "あっさり軽め", description: "サラダや麺などさっぱり系", tags: %w[light fresh quick] },
        { key: "hearty", label: "しっかり食べたい", description: "ご飯ものやガッツリ系", tags: %w[hearty rice] },
        { key: "snack", label: "おつまみ・おやつ", description: "小腹を満たす一品", tags: %w[snack casual] },
        { key: "hot", label: "あったかメニュー", description: "スープや煮込みなど", tags: %w[hot comfort] }
      ]
    },
    {
      id: "time",
      text: "調理に使える時間は？",
      hint: "今すぐ作れる目安で選んでください",
      choices: [
        { key: "under_10", label: "10分以内", description: "とにかく早く食べたい", tags: %w[quick easy] },
        { key: "under_20", label: "20分くらい", description: "手早くでもちゃんと作りたい", tags: %w[moderate] },
        { key: "under_40", label: "40分くらい", description: "じっくり作る余裕がある", tags: %w[slow cooking] },
        { key: "no_cook", label: "火を使わない", description: "サラダや冷製メニュー中心", tags: %w[nocook fresh] }
      ]
    },
    {
      id: "genre",
      text: "今食べたいジャンルは？",
      hint: "いちばん惹かれるものを選んでください",
      choices: [
        { key: "japanese", label: "和食", description: "ごはん・お味噌汁・定食系", tags: %w[japanese] },
        { key: "western", label: "洋食", description: "パスタ・サンドイッチなど", tags: %w[western] },
        { key: "asian", label: "アジアン", description: "エスニック・スパイシー系", tags: %w[asian spicy] },
        { key: "anything", label: "なんでもOK", description: "おすすめに任せたい", tags: %w[flexible] }
      ]
    }
  ].freeze

  def top
    @featured_recipes = [
      { title: "春野菜の彩りパスタ", minutes: 15 },
      { title: "かんたんクリーム親子丼", minutes: 10 },
      { title: "具だくさんミネストローネ", minutes: 20 }
    ]

    @chef_tips = [
      {
        title: "旬の食材を活かすコツ",
        body: "今の時期に美味しい野菜の選び方と保存法をご紹介。",
        icon: "lightbulb"
      },
      {
        title: "失敗しない下味の黄金比",
        body: "肉・魚・野菜別の基本の味つけバランスをチェック。",
        icon: "target"
      }
    ]
  end

  def start
    count = params[:question_count].to_i

    unless ALLOWED_QUESTION_COUNTS.include?(count)
      redirect_to root_path, alert: "コースを選んでください"
      return
    end

    session[:question_count] = count
    session[:current_question_index] = 0
    session[:answers] = []
    session.delete(:history_saved)

    redirect_to diagnostics_question_path
  end

  def question
    unless session[:question_count]
      redirect_to root_path, alert: "先にコースを選んでください"
      return
    end

    index = session[:current_question_index] || 0

    if index >= MOCK_QUESTIONS.size
      redirect_to diagnostics_result_path
      return
    end

    @current_question_index = index
    @current_question = index + 1
    @question_count = MOCK_QUESTIONS.size
    @course_label = COURSE_LABELS[session[:question_count]] || "診断コース"
    @question = MOCK_QUESTIONS[index]
  end

  def answer
    unless session[:question_count]
      redirect_to root_path, alert: "先にコースを選んでください"
      return
    end

    index = session[:current_question_index] || 0
    question = MOCK_QUESTIONS[index]
    choice = question&.dig(:choices)&.find { |item| item[:key] == params[:choice_key] }

    unless choice
      redirect_to diagnostics_question_path, alert: "選択肢が正しくありません"
      return
    end

    session[:answers] ||= []
    session[:answers] << {
      "question_index" => index,
      "question_id" => question[:id],
      "choice_key" => choice[:key],
      "choice_label" => choice[:label],
      "tags" => choice[:tags]
    }

    session[:current_question_index] = index + 1

    if session[:current_question_index] >= MOCK_QUESTIONS.size
      redirect_to diagnostics_result_path
    else
      redirect_to diagnostics_question_path
    end
  end

  def result
    unless session[:answers].present?
      redirect_to root_path, alert: "診断が完了していません"
      return
    end

    @answers = session[:answers]
    @course_label = COURSE_LABELS[session[:question_count]] || "診断コース"
    @collected_tags = @answers.flat_map { |answer| answer["tags"] }.uniq
    @dish = Dish.match_by_tag_names(@collected_tags)
    save_history_if_needed
  end

  def history_index
    @histories = History.includes(:dish).order(created_at: :desc).page(params[:page]).per(10)
  end

  def history_show
    @history = History.includes(:dish).find(params[:id])
    @dish = @history.dish
  rescue ActiveRecord::RecordNotFound
    redirect_to diagnostic_histories_path, alert: "履歴が見つかりませんでした"
  end

  def history_destroy
    history = History.find(params[:id])
    history.destroy!
    redirect_to diagnostic_histories_path, notice: "履歴を削除しました"
  rescue ActiveRecord::RecordNotFound
    redirect_to diagnostic_histories_path, alert: "履歴が見つかりませんでした"
  end

  def history_clear
    History.destroy_all
    redirect_to diagnostic_histories_path, notice: "すべての履歴をクリアしました"
  end

  private

  def save_history_if_needed
    return unless @dish
    return if session[:history_saved]

    History.create!(dish: @dish)
    session[:history_saved] = true
  end
end
