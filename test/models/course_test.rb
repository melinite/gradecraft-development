require 'test_helper'

class CourseTest < ActiveSupport::TestCase
  test "user_term returns default Player if no term set" do
    assert_equal "Player", course.user_term
  end

  test "team_term returns default Team if no term set" do
    assert_equal "Team", course.team_term
  end

  test "group_term returns default Group if no term set" do
    assert_equal "Group", course.group_term
  end

  test "section_leader_term returns default Team Leader if no term set" do
    assert_equal "Team Leader", course.section_leader_term
  end

  test "weight_term returns default Multiplier if no term set" do
    assert_equal "Multiplier", course.weight_term
  end

  def course
    @course ||= build_course
  end
end
