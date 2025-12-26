require 'test_helper'

class QuizAttemptsServiceTest < ActiveSupport::TestCase
  test 'start creates a quiz attempt' do
    result = QuizAttemptsService.new.start(user_id: users(:one).id, quiz_id: quizzes(:one).id)

    assert result.success?
    assert_equal 'in_progress', result.data['status']
  end

  test 'submit calculates score and feedback' do
    quiz = Quiz.create!(title: 'Service Attempt Quiz', description: 'Desc')
    attempt = QuizAttempt.create!(
      user: users(:one),
      quiz: quiz,
      started_at: Time.current,
      status: 'in_progress'
    )

    question = quiz.questions.create!(body: 'Q1', explanation: 'E1')
    correct_option = question.options.create!(text: 'Right', correct: true)
    question.options.create!(text: 'Wrong', correct: false)

    result = QuizAttemptsService.new.submit(
      quiz_attempt_id: attempt.id,
      answers: [{ question_id: question.id, option_id: correct_option.id }]
    )

    assert result.success?
    assert_equal 100, result.data[:score]
    assert result.data[:feedback].present?
  end
end
