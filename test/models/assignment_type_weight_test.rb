require 'test_helper'

class AssignmentTypeWeightTest < ActiveSupport::TestCase
  include ValidAttribute::Method

  test "calculates assignment weight" do
    create_assignment_weight(weight: 3)
    assert_equal 3, AssignmentTypeWeight.new(student, assignment_type).weight
  end

  test "saves assignment weights" do
    create_assignments(2)
    AssignmentTypeWeight.new(student, assignment_type).save
    assert_equal 2, assignment_type.assignment_weights.count
  end
end
