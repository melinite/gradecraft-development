require 'test_helper'

class AssignmentTypeTest < ActiveSupport::TestCase
  test "calculates point total for student" do
    [300, 500].each do |point_total|
      create_assignment(:point_total => point_total)
    end
    assert_equal 800, assignment_type.point_total_for_student(student)
  end

  test "calculates weighted point total for student" do
    @assignment_type = create_assignment_type(:student_weightable => true)
    [300, 500].each do |point_total|
      create_assignment(:point_total => point_total) do
        create_assignment_weight(:weight => 2)
      end
    end
    assert_equal 1600, assignment_type.point_total_for_student(student)
  end

  test "calculates score for student" do
    create_grades(2) # raw scores: 200, 400
    assert_equal 600, assignment_type.score_for_student(student)
  end

  test "calculates 2x score for student" do
    @assignment_type = create_assignment_type(:student_weightable => true)
    [200, 400].each do |raw_score|
      create_assignment do
        create_task do
          create_submission do
            create_grade(:raw_score => raw_score)
          end
        end
        create_assignment_weight(:weight => 2)
      end
    end
    assert_equal 1200, assignment_type.score_for_student(student)
  end

  # Max weight for any particular assignment type
  # Total weight equals total available weight

  #what is the assignment type weight structure for the course

  #what date does the multiplier need to be set by

  #how will this assignment type be displayed in the predictor?

  #how many total points is this assignment type worth?

  #does this assignment type have levels?

  #does this assignment type have assignments coming up soon?

  #is this assignment type mass gradeable? 

  #how is this assignment graded?

  #calculating group grades for students

  #calculating individual grades for students

  #calculating team grades for students

  #calculating score for student

  #multiplier for student
end
