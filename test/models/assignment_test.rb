require 'test_helper'

class AssignmentTest < ActiveSupport::TestCase
  test "can detect when a weight is not set" do
    refute assignment.weight_for_student?(student)
  end

  test "can detect when a weight is set" do
    create_assignment_weight
    assert assignment.weight_for_student?(student)
  end

  test "returns default weight if no weight is set" do
    assert_in_delta 0.5, assignment.weight_for_student(student)
  end

  test "returns default student weight if weight is 0" do
    create_assignment_weight(:weight => 0)
    assert_in_delta 0.5, assignment.weight_for_student(student)
  end

  test "returns assignment weight" do
    create_assignment_weight(:weight => 2)
    assert_in_delta 2, assignment.weight_for_student(student)
  end

  test "returns point total for student" do
    @assignment = create_assignment(:point_total => 300)
    create_assignment_weight(:weight => 2)
    assert_equal 600, @assignment.point_total_for_student(student)
  end

  def course
    @course ||= create_course(:default_assignment_weight => 0.5)
  end

  def assignment_type
    @assignment_type ||= create_assignment_type(:student_weightable => true)
  end
end
