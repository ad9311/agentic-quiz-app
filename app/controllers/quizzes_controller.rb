class QuizzesController < ApplicationController
  def index
    result = quizzes_service.list
    render(json: result.data)
  end

  def show
    result = quizzes_service.fetch(params[:id])
    if result.success?
      render(json: result.data)
    else
      render(json: { errors: result.errors }, status: :not_found)
    end
  end

  def create
    result = quizzes_service.create(quiz_params)
    if result.success?
      render(json: result.data, status: :created)
    else
      render(json: { errors: result.errors }, status: :unprocessable_entity)
    end
  end

  private

  def quizzes_service
    @quizzes_service ||= QuizzesService.new
  end

  def quiz_params
    params.require(:quiz).permit(
      :title,
      :description,
      questions: [
        :body,
        :explanation,
        { options: %i[text correct] }
      ]
    )
  end
end
