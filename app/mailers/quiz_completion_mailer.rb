class QuizCompletionMailer < ApplicationMailer
  def completion(user:, quiz:, score:, total_questions:)
    @user = user
    @quiz = quiz
    @score = score
    @total_questions = total_questions

    mail to: @user.email, subject: "You completed #{@quiz.title}"
  end
end
