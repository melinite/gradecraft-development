require 'test_helper'

class EarnedBadgeTest < ActiveSupport::TestCase
  test "sets type automatically" do
    assert_equal 'EarnedBadge', EarnedBadge.new.type
  end

  test "sets badge from submission before validation" do
    @earned_badge = build_earned_badge
    @earned_badge.valid?
    assert_equal @earned_badge.badge, submission.assignment
  end

  test "sets course from badge before validation" do
    @earned_badge = build_earned_badge
    @earned_badge.valid?
    assert_equal @earned_badge.course, badge.course
  end

  def assignment
    @assignment ||= create_badge
  end
end
