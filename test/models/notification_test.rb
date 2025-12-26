require 'test_helper'

class NotificationTest < ActiveSupport::TestCase
  test 'requires status' do
    notification = Notification.new(quiz_attempt: quiz_attempts(:one))

    assert_not notification.valid?
    assert_includes notification.errors[:status], "can't be blank"
  end

  test 'requires valid status' do
    notification = Notification.new(quiz_attempt: quiz_attempts(:one), status: 'unknown')

    assert_not notification.valid?
    assert_includes notification.errors[:status], 'is not included in the list'
  end
end
