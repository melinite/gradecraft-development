require 'test_helper'

class BadgeTest < ActiveSupport::TestCase
  test "sets course from badge set before validation" do
    @badge = build_badge
    @badge.valid?
    assert_equal @badge.course, badge_set.course
  end
end
