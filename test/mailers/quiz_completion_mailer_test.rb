require "test_helper"
require "ostruct"

class QuizCompletionMailerTest < ActionMailer::TestCase
  test "completion" do
    user = OpenStruct.new(email: "learner@example.com", name: "Avery")
    quiz = OpenStruct.new(title: "Agent Design Fundamentals")

    mail = QuizCompletionMailer.completion(
      user: user,
      quiz: quiz,
      score: 8,
      total_questions: 10
    )

    assert_equal "You completed Agent Design Fundamentals", mail.subject
    assert_equal [ "learner@example.com" ], mail.to
    assert_equal [ "from@example.com" ], mail.from
    assert_match "Avery", mail.body.encoded
  end
end
