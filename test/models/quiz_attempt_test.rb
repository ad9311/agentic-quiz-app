require 'test_helper'

class QuizAttemptTest < ActiveSupport::TestCase
  test 'requires started_at' do
    attempt = QuizAttempt.new(user: users(:one), quiz: quizzes(:one), status: 'pending')

    assert_not attempt.valid?
    assert_includes attempt.errors[:started_at], "can't be blank"
  end

  test 'requires valid status' do
    attempt = QuizAttempt.new(
      user: users(:one),
      quiz: quizzes(:one),
      started_at: Time.current,
      status: 'invalid'
    )

    assert_not attempt.valid?
    assert_includes attempt.errors[:status], 'is not included in the list'
  end
end
