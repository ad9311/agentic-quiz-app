require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "requires email" do
    user = User.new(name: "Test User")

    assert_not user.valid?
    assert_includes user.errors[:email], "can't be blank"
  end

  test "requires name" do
    user = User.new(email: "test@example.com")

    assert_not user.valid?
    assert_includes user.errors[:name], "can't be blank"
  end

  test "requires unique email" do
    existing = users(:one)
    user = User.new(email: existing.email, name: "Another User")

    assert_not user.valid?
    assert_includes user.errors[:email], "has already been taken"
  end
end
