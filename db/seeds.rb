# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

quizzes = [
  {
    title: 'Agent Design Fundamentals',
    description: '<p>Core patterns for building reliable AI agents.</p>',
    questions: [
      {
        body: '<p><strong>What is the primary role</strong> of a planner in an agentic workflow?</p>',
        explanation: '<p>Planners break goals into ordered steps and assign responsibilities.</p>',
        options: [
          { text: 'Decompose goals into sequenced steps and assign responsibilities', correct: true },
          { text: 'Store long-term memory across user sessions', correct: false },
          { text: 'Only execute tools without reasoning', correct: false },
          { text: 'Replace evaluations with random selection', correct: false }
        ]
      },
      {
        body: '<p>Which pattern best reduces <em>tool overuse</em> while keeping accuracy high?</p>',
        explanation: '<p>Use a gate that checks if a tool call is necessary before invoking it.</p>',
        options: [
          { text: 'Always call tools for every user request', correct: false },
          { text: 'Use a tool gate that validates necessity and input readiness', correct: true },
          { text: 'Disable tools to avoid latency', correct: false },
          { text: 'Call all tools in parallel on every step', correct: false }
        ]
      }
    ]
  },
  {
    title: 'Prompt Engineering Tactics',
    description: '<p>Techniques to shape outputs and reduce ambiguity.</p>',
    questions: [
      {
        body: '<p>Why include a <strong>format contract</strong> in prompts?</p>',
        explanation: '<p>It sets an explicit structure that improves consistency and parsing.</p>',
        options: [
          { text: 'It makes prompts shorter by default', correct: false },
          { text: 'It guarantees deterministic outputs', correct: false },
          { text: 'It enforces a predictable structure for responses', correct: true },
          { text: 'It removes the need for evaluation', correct: false }
        ]
      },
      {
        body: '<p>What is a good use of <em>few-shot</em> examples?</p>',
        explanation: '<p>Examples demonstrate target behavior and edge cases.</p>',
        options: [
          { text: 'To replace system instructions entirely', correct: false },
          { text: 'To demonstrate desired formatting and edge cases', correct: true },
          { text: 'To avoid specifying constraints', correct: false },
          { text: 'To increase randomness', correct: false }
        ]
      }
    ]
  }
]

quizzes.each do |quiz_data|
  quiz = Quiz.find_or_create_by!(title: quiz_data[:title]) do |record|
    record.description = quiz_data[:description]
  end

  quiz_data[:questions].each do |question_data|
    question = quiz.questions.find_or_create_by!(body: question_data[:body]) do |record|
      record.explanation = question_data[:explanation]
    end

    question_data[:options].each do |option_data|
      question.options.find_or_create_by!(text: option_data[:text], correct: option_data[:correct])
    end
  end
end
