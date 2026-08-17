class DiagnosticsController < ApplicationController
  allow_unauthenticated_access only: %i[top start question answer back quit result]
  ALLOWED_QUESTION_COUNTS = [10, 20, 30].freeze

  COURSE_LABELS = {
    10 => "かんたんコース",
    20 => "ふつうコース",
    30 => "じっくりコース"
  }.freeze

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

    clear_diagnostic_session!
    session[:question_count] = count
    session[:question_order] = DiagnosticQuestionBank.build_question_order(count)
    session[:current_question_index] = 0
    session[:answers] = []

    redirect_to diagnostics_question_path
  end

  def question
    unless session[:question_count]
      redirect_to root_path, alert: "先にコースを選んでください"
      return
    end

    question_order = session[:question_order] || []
    index = session[:current_question_index] || 0

    if index >= question_order.size
      redirect_to diagnostics_result_path
      return
    end

    @current_question_index = index
    @current_question = index + 1
    @question_count = question_order.size
    @course_label = COURSE_LABELS[session[:question_count]] || "診断コース"
    @question = DiagnosticQuestionBank.find(question_order[index])
  end

  def answer
    unless session[:question_count]
      redirect_to root_path, alert: "先にコースを選んでください"
      return
    end

    question_order = session[:question_order] || []
    index = session[:current_question_index] || 0

    question = DiagnosticQuestionBank.find(question_order[index])
    choice = question&.dig(:choices)&.find { |item| item[:key] == params[:choice_key] }

    unless choice
      redirect_to diagnostics_question_path, alert: "選択肢が正しくありません"
      return
    end

    session[:answers] ||= []
    session[:answers] << {
      "q" => question[:id],
      "c" => choice[:key]
    }

    session[:current_question_index] = index + 1

    if session[:current_question_index] >= question_order.size
      redirect_to diagnostics_result_path
    else
      redirect_to diagnostics_question_path
    end
  end

  def back
    unless session[:question_count]
      redirect_to root_path, alert: "先にコースを選んでください"
      return
    end

    index = session[:current_question_index] || 0

    if index <= 0
      redirect_to diagnostics_question_path, alert: "これ以上戻れません"
      return
    end

    session[:current_question_index] = index - 1
    session[:answers]&.pop

    redirect_to diagnostics_question_path
  end

  def quit
    clear_diagnostic_session!
    redirect_to root_path, notice: "診断を終了しました"
  end

  def result
    unless session[:answers].present?
      redirect_to root_path, alert: "診断が完了していません"
      return
    end

    ensure_dish_catalog!

    @course_label = COURSE_LABELS[session[:question_count]] || "診断コース"
    @collected_tags = DiagnosticQuestionBank.collected_tags_from_answers(session[:answers])
    @recommendations_by_category = Dish.recommendations_by_category(@collected_tags, limit_per_category: 3)
    @dish = @recommendations_by_category[:main]&.first || Dish.match_by_tag_names(@collected_tags).first
    @favorite_dish_ids = current_user&.favorites&.pluck(:dish_id) || []
    save_history_if_needed
  end

  def history_index
    @histories = current_user.histories.includes(:dish).order(created_at: :desc).page(params[:page]).per(10)
  end

  def history_show
    @history = current_user.histories.includes(:dish).find(params[:id])
    @diagnosed_at = @history.created_at
    @course_label = @history.course_label.presence || "診断コース"
    @collected_tags = Array(@history.collected_tags)
    @recommendations_by_category = @history.recommendations_by_category
    @dish = @history.dish
    @favorite_dish_ids = current_user&.favorites&.pluck(:dish_id) || []
  rescue ActiveRecord::RecordNotFound
    redirect_to diagnostic_histories_path, alert: "履歴が見つかりませんでした"
  end

  def history_destroy
    history = current_user.histories.find(params[:id])
    history.destroy!
    redirect_to diagnostic_histories_path, notice: "履歴を削除しました"
  rescue ActiveRecord::RecordNotFound
    redirect_to diagnostic_histories_path, alert: "履歴が見つかりませんでした"
  end

  def history_clear
    current_user.histories.destroy_all
    redirect_to diagnostic_histories_path, notice: "すべての履歴をクリアしました"
  end

  private

  def clear_diagnostic_session!
    session.delete(:question_count)
    session.delete(:question_order)
    session.delete(:current_question_index)
    session.delete(:answers)
    session.delete(:history_saved)
  end

  def ensure_dish_catalog!
    return unless Dish.none?
    return unless Rails.env.development?

    Rails.application.load_seed
  end

  def save_history_if_needed
    return unless @dish
    return unless current_user
    return if session[:history_saved]

    recommendations_payload = @recommendations_by_category.transform_values do |dishes|
      dishes.map(&:id)
    end

    current_user.histories.create!(
      dish: @dish,
      course_label: @course_label,
      question_count: session[:question_count],
      collected_tags: @collected_tags,
      recommendations: recommendations_payload
    )
    session[:history_saved] = true
  end
end
