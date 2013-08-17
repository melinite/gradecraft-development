require 'test_helper'

class AssignmentTypeWeightTest < ActiveSupport::TestCase
  include ValidAttribute::Method

  test "calculates weight" do
    create_assignment do
      create_assignment_weight(weight: 3)
    end
    create_assignment do
      create_assignment_weight(weight: 3)
    end
    assert_equal 3, AssignmentTypeWeight.new(student, assignment_type).weight
  end

  test "saves assignment weights" do
    create_assignments(2)
    AssignmentTypeWeight.new(student, assignment_type).save
    assert_equal 2, assignment_type.assignment_weights.count
  end

  test "adds an error when assignment weight exceeds course max assignment weight" do
    create_course(:max_assignment_weight => 2) do
      @assignment_type_weight = AssignmentTypeWeight.new(student, assignment_type)
    end
    assert_must have_valid(:weight).when(2), @assignment_type_weight
    assert_wont have_valid(:weight).when(3), @assignment_type_weight
  end
end
