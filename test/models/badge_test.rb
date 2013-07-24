require 'test_helper'

class BadgeTest < ActiveSupport::TestCase
  test "sets type automatically" do
    assert_equal 'Badge', Badge.new.type
  end

  test "sets course from badge set before validation" do
    @badge = build_badge
    @badge.valid?
    assert_equal @badge.course, badge_set.course
  end
end
