require 'test_helper'

class GradeSchemeTest < ActiveSupport::TestCase
  include ValidAttribute::Method

  test "returns a grade level for a score" do
    grade_scheme.elements << Fabricate(:grade_scheme_element, level: 'Outstanding', low_range: 90, high_range: 100)
    assert_equal 'Outstanding', grade_scheme.level(100)
  end

  test "returns a grade letter for a score" do
    grade_scheme.elements << Fabricate(:grade_scheme_element, letter: 'A', low_range: 90, high_range: 100)
    assert_equal 'A', grade_scheme.letter(100)
  end
end
