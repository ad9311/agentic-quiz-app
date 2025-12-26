require 'test_helper'

class QuizTest < ActiveSupport::TestCase
  test 'requires title' do
    quiz = Quiz.new(description: 'Desc')

    assert_not quiz.valid?
    assert_includes quiz.errors[:title], "can't be blank"
  end

  test 'requires unique title' do
    existing = quizzes(:one)
    quiz = Quiz.new(title: existing.title, description: 'Another')

    assert_not quiz.valid?
    assert_includes quiz.errors[:title], 'has already been taken'
  end
end
