# Preview all emails at http://localhost:3000/rails/mailers/quiz_completion_mailer
class QuizCompletionMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/quiz_completion_mailer/completion
  def completion
    require "ostruct"

    user = OpenStruct.new(email: "learner@example.com", name: "Avery")
    quiz = OpenStruct.new(title: "Agent Design Fundamentals")

    QuizCompletionMailer.completion(
      user: user,
      quiz: quiz,
      score: 8,
      total_questions: 10
    )
  end
end
