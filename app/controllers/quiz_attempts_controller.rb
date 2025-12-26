class QuizAttemptsController < ApplicationController
  def create
    result = quiz_attempts_service.start(
      user_id: start_params[:user_id],
      quiz_id: start_params[:quiz_id]
    )

    if result.success?
      render(json: result.data, status: :created)
    else
      render(json: { errors: result.errors }, status: :unprocessable_entity)
    end
  end

  def submit
    result = quiz_attempts_service.submit(
      quiz_attempt_id: params[:id],
      answers: submit_params[:answers]
    )

    if result.success?
      render(json: result.data)
    else
      render(json: { errors: result.errors }, status: :unprocessable_entity)
    end
  end

  private

  def quiz_attempts_service
    @quiz_attempts_service ||= QuizAttemptsService.new
  end

  def start_params
    params.require(:quiz_attempt).permit(:user_id, :quiz_id)
  end

  def submit_params
    params.require(:quiz_attempt).permit(answers: %i[question_id option_id])
  end
end
