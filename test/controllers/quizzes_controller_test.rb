require 'test_helper'

class QuizzesControllerTest < ActionDispatch::IntegrationTest
  test 'index returns quizzes with summary fields' do
    get quizzes_url

    assert_response :success
    payload = response.parsed_body

    assert(payload.all? { |quiz| quiz.keys.sort == %w[description id title] })
  end

  test 'show returns quiz details without correct answers' do
    quiz = quizzes(:one)

    get quiz_url(quiz)

    assert_response :success
    payload = response.parsed_body
    options = payload.fetch('questions').flat_map { |question| question.fetch('options') }

    assert options.any?
    assert(options.all? { |option| option.keys.sort == %w[id text] })
  end

  test 'create persists a quiz with questions and options' do
    payload = {
      quiz: {
        title: 'API Quiz',
        description: 'API description',
        questions: [
          {
            body: 'What is Rails?',
            explanation: 'Framework question',
            options: [
              { text: 'A Ruby web framework', correct: true },
              { text: 'A database', correct: false }
            ]
          }
        ]
      }
    }

    assert_difference('Quiz.count', 1) do
      assert_difference('Question.count', 1) do
        assert_difference('Option.count', 2) do
          post quizzes_url, params: payload
        end
      end
    end

    assert_response :created
    response_payload = response.parsed_body
    options = response_payload.fetch('questions').flat_map { |question| question.fetch('options') }

    assert options.any?
    assert(options.all? { |option| option.keys.sort == %w[id text] })
  end
end
