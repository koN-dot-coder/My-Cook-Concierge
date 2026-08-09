require "test_helper"

class DiagnosticsControllerTest < ActionDispatch::IntegrationTest
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

  test "answer advances through questions and completes diagnosis" do
    post diagnostics_start_url, params: { question_count: 10 }
    follow_redirect!
    assert_match "今の気分に近いのはどれ", response.body

    post diagnostics_answer_url, params: { choice_key: "light" }
    follow_redirect!
    assert_response :success
    assert_match "調理に使える時間は", response.body
    assert_match "QUESTION 2 / 3", response.body

    post diagnostics_answer_url, params: { choice_key: "under_20" }
    follow_redirect!
    assert_response :success
    assert_match "今食べたいジャンルは", response.body
    assert_match "QUESTION 3 / 3", response.body

    post diagnostics_answer_url, params: { choice_key: "japanese" }
    follow_redirect!
    assert_response :success
    assert_match "診断が完了しました", response.body
    assert_match "あっさり軽め", response.body
    assert_match "#light", response.body
    assert_equal 3, session[:answers].size
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
end
