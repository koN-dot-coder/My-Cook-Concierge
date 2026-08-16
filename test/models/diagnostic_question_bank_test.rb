require "test_helper"

class DiagnosticQuestionBankTest < ActiveSupport::TestCase
  test "choice_tags returns tags for a valid choice" do
    tags = DiagnosticQuestionBank.choice_tags("mood", "refreshed")

    assert_includes tags, "light"
    assert_includes tags, "fresh"
  end

  test "collected_tags_from_answers rebuilds tags from compact session answers" do
    answers = [
      { "q" => "mood", "c" => "refreshed" },
      { "q" => "time", "c" => "quick" }
    ]

    tags = DiagnosticQuestionBank.collected_tags_from_answers(answers)

    assert_includes tags, "light"
    assert_includes tags, "quick"
    assert_equal tags, tags.uniq
  end

  test "collected_tags_from_answers supports legacy answer format" do
    answers = [
      { "question_id" => "mood", "choice_key" => "comfort", "tags" => %w[comfort umami] }
    ]

    tags = DiagnosticQuestionBank.collected_tags_from_answers(answers)

    assert_equal %w[comfort umami], tags
  end
end
