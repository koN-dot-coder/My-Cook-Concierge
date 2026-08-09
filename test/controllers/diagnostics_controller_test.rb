require "test_helper"

class DiagnosticsControllerTest < ActionDispatch::IntegrationTest
  setup do
    Rails.application.load_seed if Dish.none?
    History.delete_all
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
    assert_equal 0, session[:current_question_index]
    assert_equal [], session[:answers]
  end

  test "question requires start first" do
    get diagnostics_question_url
    assert_redirected_to root_url
  end

  test "question shows first mock question after start" do
    post diagnostics_start_url, params: { question_count: 20 }
    follow_redirect!
    assert_response :success
    assert_match "今の気分に近いのはどれ", response.body
    assert_match "QUESTION 1 / 3", response.body
    assert_match "ふつうコース", response.body
  end

  test "answer advances through questions and shows matched dish on result" do
    post diagnostics_start_url, params: { question_count: 10 }
    follow_redirect!

    post diagnostics_answer_url, params: { choice_key: "light" }
    follow_redirect!

    post diagnostics_answer_url, params: { choice_key: "under_20" }
    follow_redirect!

    post diagnostics_answer_url, params: { choice_key: "japanese" }
    follow_redirect!

    assert_response :success
    assert_match "あなたへのおすすめ", response.body
    assert_match "TODAY'S PICK", response.body
    assert_match Dish.match_by_tag_names(%w[light fresh quick moderate japanese]).name, response.body
    assert_equal 3, session[:answers].size
    assert_equal 1, History.count
    assert session[:history_saved]
  end

  test "result does not duplicate history on refresh" do
    complete_diagnosis

    assert_equal 1, History.count

    get diagnostics_result_url
    assert_response :success
    assert_equal 1, History.count
  end

  test "history index shows saved histories" do
    complete_diagnosis

    get diagnostic_histories_url
    assert_response :success
    assert_match "過去の診断履歴", response.body
    assert_match Dish.match_by_tag_names(%w[light fresh quick moderate japanese]).name, response.body
  end

  test "history show displays dish detail" do
    complete_diagnosis
    history = History.last

    get diagnostic_history_url(history)
    assert_response :success
    assert_match history.dish.name, response.body
  end

  test "history show redirects when not found" do
    get diagnostic_history_url(id: 0)
    assert_redirected_to diagnostic_histories_url
  end

  test "history_destroy deletes a record" do
    complete_diagnosis
    history = History.last

    assert_difference("History.count", -1) do
      delete diagnostic_history_path(history)
    end

    assert_redirected_to diagnostic_histories_url
    follow_redirect!
    assert_match "履歴を削除しました", response.body
  end

  test "history_clear deletes all records" do
    complete_diagnosis
    complete_diagnosis
    assert_equal 2, History.count

    delete clear_diagnostic_histories_url

    assert_redirected_to diagnostic_histories_url
    assert_equal 0, History.count
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

  def complete_diagnosis
    post diagnostics_start_url, params: { question_count: 10 }
    follow_redirect!
    post diagnostics_answer_url, params: { choice_key: "light" }
    follow_redirect!
    post diagnostics_answer_url, params: { choice_key: "under_20" }
    follow_redirect!
    post diagnostics_answer_url, params: { choice_key: "japanese" }
    follow_redirect!
  end
end
