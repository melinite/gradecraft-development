require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def valid_params 
    { username: "hermione.granger", email: "hermione.granger@hogwarts.edu" }
  end

  def test_valid
    user = User.new valid_params

    assert user.valid?, "Can't create with valid params: #{user.errors.messages}"
  end
  # test "calculates score for course" do
  #   create_grades(2) # raw scores: 200, 400
  #   assert_equal 600, student.score_for_course(course)
  # end

  # test "calculates weighted score for course" do
  #   @assignment_type = create_assignment_type(:student_weightable => true)
  #   [200, 400].each do |raw_score|
  #     create_assignment do
  #       create_grade(:raw_score => raw_score)
  #       create_assignment_weight(:weight => 2)
  #     end
  #   end
  #   assert_equal 1200, student.score_for_course(course)
  # end
end
