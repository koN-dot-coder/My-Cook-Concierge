require "test_helper"

class DiagnosticsControllerTest < ActionDispatch::IntegrationTest
  setup do
    Rails.application.load_seed if Dish.none?
    History.delete_all
    @user = users(:one)
    sign_in_as(@user)
  end

  test "should get top" do
    get diagnostics_top_url
    assert_response :success
    assert_match "かんたん", response.body
    assert_match "今日の注目レシピ", response.body
    assert_match "料理家の知恵袋", response.body
  end

  test "start saves question count and redirects to question" do
    post diagnostics_start_url, params: { question_count: 10 }
    assert_redirected_to diagnostics_question_url
    assert_equal 10, session[:question_count]
    assert_equal 10, session[:question_order].size
    assert_equal 0, session[:current_question_index]
    assert_equal [], session[:answers]
  end

  test "question requires start first" do
    get diagnostics_question_url
    assert_redirected_to root_url
  end

  test "question shows first tier one question after start" do
    post diagnostics_start_url, params: { question_count: 20 }
    follow_redirect!
    assert_response :success
    assert_match "今の気分にいちばん近いのは", response.body
    assert_match "Question 1 of 20", response.body
    assert_match "ふつうコース", response.body
  end

  test "answer advances through questions and shows matched dishes on result" do
    complete_diagnosis(question_count: 10)

    assert_response :success
    assert_match "本日の専用メニュー", response.body
    assert_no_match "PICK", response.body
    assert_match "主食", response.body
    assert_match "主菜", response.body
    assert_match "ドリンク", response.body
    assert_equal 10, session[:answers].size
    assert_equal 1, @user.histories.count
    assert session[:history_saved]
    assert_equal @user, History.last.user
  end

  test "guest diagnosis does not save history" do
    delete session_url
    follow_redirect!

    complete_diagnosis(question_count: 10)

    assert_response :success
    assert_equal 0, History.count
    assert_not session[:history_saved]
  end

  test "thirty question course uses all tiers" do
    post diagnostics_start_url, params: { question_count: 30 }
    assert_equal 30, session[:question_order].size
  end

  test "result does not duplicate history on refresh" do
    complete_diagnosis

    assert_equal 1, @user.histories.count

    get diagnostics_result_url
    assert_response :success
    assert_equal 1, @user.histories.count
  end

  test "history index requires authentication" do
    delete session_url
    follow_redirect!

    get diagnostic_histories_url
    assert_redirected_to new_session_url
  end

  test "history index shows saved histories for current user" do
    complete_diagnosis
    history_dish_name = @user.histories.last.dish.name

    get diagnostic_histories_url
    assert_response :success
    assert_match "過去の診断履歴", response.body
    assert_match history_dish_name, response.body
  end

  test "history index does not show other users histories" do
    complete_diagnosis
    other_user = users(:two)
    other_dish = Dish.first
    other_history = other_user.histories.create!(dish: other_dish, course_label: "他ユーザーコース")

    get diagnostic_histories_url
    assert_response :success
    assert_no_match other_history.dish.name, response.body
  end

  test "history show displays full diagnosis result" do
    complete_diagnosis
    history = @user.histories.last

    get diagnostic_history_url(history)
    assert_response :success
    assert_match "あなたの専用メニュー", response.body
    assert_match history.dish.name, response.body
    assert_match "主食", response.body
    assert_match "主菜", response.body
    assert_no_match "本日の専用メニュー", response.body
  end

  test "saved history stores diagnosis snapshot" do
    complete_diagnosis
    history = @user.histories.last

    assert_equal "かんたんコース", history.course_label
    assert_equal 10, history.question_count
    assert history.collected_tags.present?
    assert history.recommendations.present?
  end

  test "history show redirects when not found" do
    get diagnostic_history_url(id: 0)
    assert_redirected_to diagnostic_histories_url
  end

  test "history show denies access to other users history" do
    other_history = users(:two).histories.create!(dish: Dish.first)

    get diagnostic_history_url(other_history)
    assert_redirected_to diagnostic_histories_url
  end

  test "history_destroy deletes a record" do
    complete_diagnosis
    history = @user.histories.last

    assert_difference("@user.histories.count", -1) do
      delete diagnostic_history_path(history)
    end

    assert_redirected_to diagnostic_histories_url
    follow_redirect!
    assert_match "履歴を削除しました", response.body
  end

  test "history_clear deletes only current users records" do
    complete_diagnosis
    complete_diagnosis
    other_history = users(:two).histories.create!(dish: Dish.first)
    assert_equal 2, @user.histories.count

    delete clear_diagnostic_histories_url

    assert_redirected_to diagnostic_histories_url
    assert_equal 0, @user.histories.count
    assert History.exists?(other_history.id)
    follow_redirect!
    assert_match "すべての履歴をクリアしました", response.body
  end

  test "answer rejects invalid choice" do
    post diagnostics_start_url, params: { question_count: 10 }
    follow_redirect!

    post diagnostics_answer_url, params: { choice_key: "invalid" }
    assert_redirected_to diagnostics_question_url
  end

  test "result requires completed diagnosis" do
    get diagnostics_result_url
    assert_redirected_to root_url
  end

  private

  def complete_diagnosis(question_count: 10)
    post diagnostics_start_url, params: { question_count: question_count }
    follow_redirect!

    session[:question_order].each do |question_id|
      question = DiagnosticQuestionBank.find(question_id)
      post diagnostics_answer_url, params: { choice_key: question[:choices].first[:key] }
      follow_redirect!
    end
  end
end
