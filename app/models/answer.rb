class Answer < ApplicationRecord
  belongs_to :quiz_attempt
  belongs_to :question
  belongs_to :option

  validates :correct, inclusion: { in: [true, false] }
  validates :question_id, uniqueness: { scope: :quiz_attempt_id }
end
