require 'test_helper'

class QuizAttemptsControllerTest < ActionDispatch::IntegrationTest
  test 'create starts a quiz attempt' do
    quiz = Quiz.create!(title: 'Attempt Quiz', description: 'Desc')
    payload = {
      quiz_attempt: {
        user_id: users(:one).id,
        quiz_id: quiz.id
      }
    }

    assert_difference('QuizAttempt.count', 1) do
      post quiz_attempts_url, params: payload
    end

    assert_response :created
    response_payload = response.parsed_body

    assert_equal users(:one).id, response_payload['user_id']
    assert_equal quiz.id, response_payload['quiz_id']
  end

  test 'submit scores a quiz attempt and returns feedback' do
    quiz = Quiz.create!(title: 'Submit Quiz', description: 'Desc')
    attempt = QuizAttempt.create!(
      user: users(:one),
      quiz: quiz,
      started_at: Time.current,
      status: 'in_progress'
    )

    question = quiz.questions.create!(body: 'Q1', explanation: 'E1')
    correct_option = question.options.create!(text: 'Right', correct: true)
    question.options.create!(text: 'Wrong', correct: false)

    payload = {
      quiz_attempt: {
        answers: [
          { question_id: question.id, option_id: correct_option.id }
        ]
      }
    }

    post submit_quiz_attempt_url(attempt), params: payload

    assert_response :success
    response_payload = response.parsed_body

    assert_equal attempt.id, response_payload['quiz_attempt_id']
    assert_equal 100, response_payload['score']
    assert_equal 1, response_payload['correct']
    assert_equal 1, response_payload['total']
    assert response_payload['feedback'].present?
  end
end
