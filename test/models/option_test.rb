require 'test_helper'

class OptionTest < ActiveSupport::TestCase
  test 'requires text' do
    option = Option.new(question: questions(:one), correct: false)

    assert_not option.valid?
    assert_includes option.errors[:text], "can't be blank"
  end

  test 'defaults correct to false' do
    option = Option.new(question: questions(:one), text: 'Maybe')

    assert_equal false, option.correct
  end
end
