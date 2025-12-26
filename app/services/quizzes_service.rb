class QuizzesService
  Result = Struct.new(:success?, :data, :errors, keyword_init: true)

  def list
    quizzes = Quiz.select(:id, :title, :description).order(:id)
    Result.new(success?: true, data: quizzes.map { |quiz| quiz.slice(:id, :title, :description) })
  end

  def fetch(id)
    quiz = Quiz.includes(questions: :options).find_by(id: id)
    return Result.new(success?: false, data: nil, errors: ['Quiz not found']) unless quiz

    Result.new(success?: true, data: build_quiz_payload(quiz))
  end

  def create(attributes)
    attrs = attributes.to_h.with_indifferent_access
    quiz = Quiz.new(title: attrs[:title], description: attrs[:description])

    Quiz.transaction do
      quiz.save!
      create_questions(quiz, attrs[:questions])
    end

    Result.new(success?: true, data: build_quiz_payload(quiz.reload))
  rescue ActiveRecord::RecordInvalid => e
    Result.new(success?: false, data: nil, errors: e.record.errors.full_messages)
  end

  private

  def build_quiz_payload(quiz)
    {
      id: quiz.id,
      title: quiz.title,
      description: quiz.description,
      questions: quiz.questions.map do |question|
        {
          id: question.id,
          body: question.body,
          explanation: question.explanation,
          options: question.options.map { |option| { id: option.id, text: option.text } }
        }
      end
    }
  end

  def create_questions(quiz, questions_attributes)
    Array(questions_attributes).each do |question_attributes|
      attrs = question_attributes.to_h.with_indifferent_access
      question = quiz.questions.create!(
        body: attrs[:body],
        explanation: attrs[:explanation]
      )
      create_options(question, attrs[:options])
    end
  end

  def create_options(question, options_attributes)
    Array(options_attributes).each do |option_attributes|
      attrs = option_attributes.to_h.with_indifferent_access
      question.options.create!(
        text: attrs[:text],
        correct: attrs.fetch(:correct, false)
      )
    end
  end
end
