require 'test_helper'

class AssignmentTest < ActiveSupport::TestCase
  include ValidAttribute::Method

  test "sets type automatically" do
    assert_equal 'Assignment', Assignment.new.type
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
    @assignment = create_assignment(:point_total => 300) do
      create_assignment_weight(:weight => 2)
    end
    assert_equal 600, @assignment.point_total_for_student(student)
  end

  test "returns assignment type point total for student" do
    [300, 400].each do |point_total|
      create_assignment(point_total: point_total) do
        create_assignment_weight(:weight => 2)
        create_grade
      end
    end
    assert_equal 1400, assignment_type.assignments.point_total_for_student(student)
  end

  test "returns course point total for student" do
    [300, 450, 100].each_with_index do |point_total, i|
      create_assignment(point_total: point_total) do
        create_assignment_weight(:weight => i + 1)
        create_grade
      end
    end
    assert_equal 1500, course.assignments.point_total_for_student(student)
  end

  test "sets course from assignment type before validation" do
    @assignment = build_assignment(:course => nil)
    @assignment.valid?
    assert_equal @assignment.course, assignment_type.course
  end

  # Custom fabricator overrides

  def course
    @course ||= create_course(:default_assignment_weight => 0.5)
  end

  def assignment_type
    @assignment_type ||= create_assignment_type(:student_weightable => true)
  end
end
