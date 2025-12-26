require 'test_helper'

class QuestionTest < ActiveSupport::TestCase
  test 'requires body' do
    question = Question.new(quiz: quizzes(:one), explanation: 'Why')

    assert_not question.valid?
    assert_includes question.errors[:body], "can't be blank"
  end
end
