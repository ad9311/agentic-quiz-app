class QuizAttempt < ApplicationRecord
  STATUSES = %w[pending in_progress completed].freeze

  belongs_to :user
  belongs_to :quiz
  has_many :answers, dependent: :destroy
  has_many :notifications, dependent: :destroy

  validates :started_at, presence: true
  validates :status, presence: true, inclusion: { in: STATUSES }
end
