require 'test_helper'

class QuizzesServiceTest < ActiveSupport::TestCase
  test 'list returns summaries only' do
    result = QuizzesService.new.list

    assert result.success?
    assert(result.data.all? { |quiz| quiz.keys.sort == %w[description id title] })
  end

  test 'fetch returns quiz details without correct answers' do
    quiz = quizzes(:one)

    result = QuizzesService.new.fetch(quiz.id)

    assert result.success?
    options = result.data.fetch(:questions).flat_map { |question| question.fetch(:options) }

    assert options.any?
    assert(options.all? { |option| option.keys.sort == %i[id text] })
  end

  test 'fetch returns error when quiz is missing' do
    result = QuizzesService.new.fetch(-1)

    assert_not result.success?
    assert_includes result.errors, 'Quiz not found'
  end

  test 'create persists quiz with questions and options' do
    payload = {
      title: 'Service Quiz',
      description: 'Service description',
      questions: [
        {
          body: 'What is Ruby?',
          explanation: 'Language question',
          options: [
            { text: 'A programming language', correct: true },
            { text: 'A database', correct: false }
          ]
        }
      ]
    }

    assert_difference('Quiz.count', 1) do
      assert_difference('Question.count', 1) do
        assert_difference('Option.count', 2) do
          result = QuizzesService.new.create(payload)
          assert result.success?
        end
      end
    end
  end

  test 'create returns validation errors' do
    result = QuizzesService.new.create(title: '', description: 'No title')

    assert_not result.success?
    assert_includes result.errors, "Title can't be blank"
  end
end
