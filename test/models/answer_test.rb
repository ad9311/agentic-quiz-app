require 'test_helper'

class AnswerTest < ActiveSupport::TestCase
  test 'requires correct to be true or false' do
    answer = Answer.new(quiz_attempt: quiz_attempts(:one), question: questions(:one), option: options(:one))

    assert_not answer.valid?
    assert_includes answer.errors[:correct], 'is not included in the list'
  end

  test 'requires unique question per attempt' do
    existing = answers(:one)
    answer = Answer.new(
      quiz_attempt: existing.quiz_attempt,
      question: existing.question,
      option: options(:two),
      correct: false
    )

    assert_not answer.valid?
    assert_includes answer.errors[:question_id], 'has already been taken'
  end
end
