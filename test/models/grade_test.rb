require 'test_helper'

class GradeTest < ActiveSupport::TestCase
  test "can exist without a task or submission" do
    Grade.create!(:student => student, :assignment => assignment)
  end

  test "can exist with a task but no submission" do
    Grade.create!(:student => student, :task => task)
  end

  test "can exist with a submission but no task" do
    Grade.create!(:submission => submission)
  end

  test "can exist with a task and a submission" do
    @submission = create_submission(:task => task)
    Grade.create!(:submission => @submission)
  end

  test "requires unique assignment ID if no task/submssion ID" do
    @grade = create_grade(:assignment_id => 1, :student_id => 1)
    @grade.save
    @another_grade = create_grade(:assignment_id => 1, :student_id => 1)
    assert !@another_grade.save
  end

  test "has different task ID if assignment IDs are the same" do
    @grade = create_grade(:assignment_id => 1, :student_id => 1, :task_id => 2)
    @grade.save
    @another_grade = create_grade(:assignment_id => 1, :student_id => 1, :task_id => 3)
    assert @another_grade.save
  end

  test "has different submission ID if assignment/task IDs are the same" do
    @grade = create_grade(:assignment_id => 1, :student_id => 1, :task_id => 2, :submission_id => 1)
    @grade.save
    @another_grade = create_grade(:assignment_id => 1, :student_id => 1, :task_id => 2, :submission_id => 2)
    assert @another_grade.save
  end

  test "caches score" do
    @grade = build_grade(:raw_score => 100)
    @grade.save
    assert_equal 100, Grade.where(:id => @grade.id).pluck('score').first
  end

  test "saves course membership score after creating" do
    assert_equal grade.raw_score, student.score_for_course(course)
  end

  test "saves course membership score after updating" do
    grade.update_attributes!(:raw_score => 400)
    assert_equal 400, student.score_for_course(course)
  end

  test "saves course membership score for each course after destroying" do
    grade
    original = student.score_for_course(course)
    grade.destroy!
    assert_equal original - grade.raw_score, student.score_for_course(course)
  end

  test "doesn't weight values if student weightable is false" do
    create_assignment_weight(:weight => 2)
    assert_equal 300, grade.score
  end

  test "calculates correct score with 2x weight" do
    @assignment_type = create_assignment_type(:student_weightable => true)
    create_assignment_weight(:weight => 2)
    assert_equal 600, grade.score
  end

  test "calculates correct score with 4x weight" do
    create_assignment_type(:student_weightable => true) do
      create_assignment_weight(:weight => 4)
    end
    assert_equal 1200, grade.score
  end

  test "uses default assignment weight if 0 weight" do
    @course = create_course(:default_assignment_weight => 0.5)
    @assignment_type = create_assignment_type(:student_weightable => true)
    create_assignment_weight(:weight => 0)
    assert_equal 150, grade.score
  end

  def grade
    @grade ||= create_grade(:raw_score => 300)
  end
end
