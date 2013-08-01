require 'test_helper'

class GradeSchemeElementTest < ActiveSupport::TestCase
  include ValidAttribute::Method

  test "grade scheme elements require a high range" do
    @element = build_grade_scheme_element(:high_range => nil)
    assert_wont have_valid(:high_range).when(nil), @element
    assert_must have_valid(:high_range).when(100), @element
  end

  test "grade scheme elements require a low range" do
    @element = build_grade_scheme_element(:low_range => nil)
    assert_wont have_valid(:low_range).when(nil), @element
    assert_must have_valid(:low_range).when(90), @element
  end

  test "grade scheme elements require high range to be greater than low range" do
    @element = build_grade_scheme_element(:low_range => 50)
    assert_wont have_valid(:high_range).when(49), @element
    assert_wont have_valid(:high_range).when(50), @element
    assert_must have_valid(:high_range).when(51), @element
  end

  test "grade scheme elements cannot overlap" do
    create_grade_scheme_element(:low_range => 90, :high_range => 100)
    @element = build_grade_scheme_element(:low_range => 80)
    assert_wont have_valid(:high_range).when(91), @element
    assert_wont have_valid(:high_range).when(90), @element
    assert_must have_valid(:high_range).when(89), @element
  end
end
