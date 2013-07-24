require 'test_helper'

class GradeTest < ActiveSupport::TestCase
  test "sets type automatically" do
    assert_equal 'Grade', Grade.new.type
  end

  test "saves course membership's sortable score after creating" do
    assert_equal grade.raw_score, student.sortable_score_for_course(course)
  end

  test "saves course membership's sortable score after updating" do
    grade.update_attributes!(:raw_score => 400)
    assert_equal 400, student.sortable_score_for_course(course)
  end

  test "saves student's sortable score for each course after destroying" do
    grade
    original = student.sortable_score_for_course(course)
    grade.destroy!
    assert_equal original - grade.raw_score, student.sortable_score_for_course(course)
  end

  test "doesn't weight values if student weightable is false" do
    create_assignment_weight(:weight => 2)
    assert_equal 300, grade.score(student)
  end

  test "calculates correct score with 2x weight" do
    @assignment_type = create_assignment_type(:student_weightable => true)
    create_assignment_weight(:weight => 2)
    assert_equal 600, grade.score(student)
  end

  test "calculates correct score with 4x weight" do
    @assignment_type = create_assignment_type(:student_weightable => true)
    create_assignment_weight(:weight => 4)
    assert_equal 1200, grade.score(student)
  end

  test "devalues scores with 0 weight" do
    @course = create_course(:total_assignment_weight => 8, :default_assignment_weight => 0.5)
    create_assignment_weight(:weight => 0)
    assert_equal 150, grade.score(student)
  end

  def grade
    @grade ||= create_grade(:raw_score => 300)
  end
end
