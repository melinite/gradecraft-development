require 'test_helper'

class AssignmentTypeTest < ActiveSupport::TestCase
  
  test "should not save assignment type without name" do
    assignment_type = AssignmentType.new
    assert !assignment_type.save, "Saved the assignment without a title"
  end

  # test "sets weight for a particular student" do

  # end

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
