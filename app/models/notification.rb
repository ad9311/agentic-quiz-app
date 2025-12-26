class Notification < ApplicationRecord
  STATUSES = %w[pending sent failed].freeze

  belongs_to :quiz_attempt

  validates :status, presence: true, inclusion: { in: STATUSES }
end
