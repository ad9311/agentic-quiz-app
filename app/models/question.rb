class Question < ApplicationRecord
  belongs_to :quiz
  has_many :options, dependent: :destroy

  validates :body, presence: true
end
