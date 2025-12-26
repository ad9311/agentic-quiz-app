class QuizAttemptsService
  Result = Struct.new(:success?, :data, :errors, keyword_init: true)

  def start(user_id:, quiz_id:)
    attempt = QuizAttempt.new(
      user_id: user_id,
      quiz_id: quiz_id,
      started_at: Time.current,
      status: 'in_progress'
    )

    if attempt.save
      Result.new(success?: true, data: attempt.slice(:id, :user_id, :quiz_id, :started_at, :status))
    else
      Result.new(success?: false, data: nil, errors: attempt.errors.full_messages)
    end
  end

  def submit(quiz_attempt_id:, answers:)
    attempt = QuizAttempt.includes(:user, quiz: :questions).find_by(id: quiz_attempt_id)
    return Result.new(success?: false, data: nil, errors: ['Quiz attempt not found']) unless attempt

    if attempt.status == 'completed'
      return Result.new(success?: false, data: nil, errors: ['Quiz attempt already completed'])
    end

    questions = attempt.quiz.questions.index_by(&:id)
    total_questions = questions.size
    return Result.new(success?: false, data: nil, errors: ['Quiz has no questions']) if total_questions.zero?

    submitted_answers =
      if answers.is_a?(ActionController::Parameters) || answers.is_a?(Hash)
        answers.values
      else
        Array(answers)
      end
    if submitted_answers.empty?
      return Result.new(success?: false, data: nil, errors: ['No answers submitted'])
    end

    correct_count = 0

    QuizAttempt.transaction do
      submitted_answers.each do |answer|
        attrs = answer.to_h.with_indifferent_access
        question = questions[attrs[:question_id].to_i]
        raise ActiveRecord::RecordInvalid, attempt unless question

        option = question.options.find_by(id: attrs[:option_id])
        raise ActiveRecord::RecordInvalid, attempt unless option

        is_correct = option.correct?
        correct_count += 1 if is_correct

        attempt.answers.create!(
          question_id: question.id,
          option_id: option.id,
          correct: is_correct
        )
      end

      score = ((correct_count.to_f / total_questions) * 100).round
      attempt.update!(score: score, status: 'completed', completed_at: Time.current)
    end

    score = attempt.score || 0
    QuizCompletionMailer.completion(
      user: attempt.user,
      quiz: attempt.quiz,
      score: score,
      total_questions: total_questions
    ).deliver_later
    Result.new(
      success?: true,
      data: {
        quiz_attempt_id: attempt.id,
        score: score,
        correct: correct_count,
        total: total_questions,
        feedback: feedback_for(score)
      }
    )
  rescue ActiveRecord::RecordInvalid
    Result.new(success?: false, data: nil, errors: ['Invalid submission'])
  end

  private

  def feedback_for(score)
    case score
    when 80..100
      'Great job! You scored 80% or higher. Keep up the excellent work!'
    when 60..79
      'Nice effort! You are close to mastery. Review the material and try again.'
    else
      'Keep going! Practice makes progress, and you can improve with another try.'
    end
  end
end
