require 'test_helper'

class AssignmentWeightTest < ActiveSupport::TestCase
  # include ValidAttribute::Method

  # test "calculates course total assignment weight when current weight is persisted" do
  #   create_assignment_weight :weight => 1, :assignment => create_assignment
  #   create_assignment_weight :weight => 2, :assignment => create_assignment
  #   @assignment_weight = create_assignment_weight :weight => 3, :assignment => create_assignment
  #   assert_equal 6, @assignment_weight.course_total_assignment_weight
  # end

  # test "calculates course total assignment weight when current weight is not persisted" do
  #   create_assignment_weight :weight => 1, :assignment => create_assignment
  #   create_assignment_weight :weight => 2, :assignment => create_assignment
  #   @assignment_weight = build_assignment_weight :weight => 3, :assignment => create_assignment
  #   assert_equal 6, @assignment_weight.course_total_assignment_weight
  # end

  # test "adds an error when course total student weight exceeds course total assignment weight" do
  #   create_course(:total_assignment_weight => 2) do
  #     @assignment_weight = build_assignment_weight
  #   end
  #   assert_must have_valid(:weight).when(2), @assignment_weight
  #   assert_wont have_valid(:weight).when(3), @assignment_weight
  # end

  # test "adds an error when assignment weight exceeds course max assignment weight" do
  #   create_course(:max_assignment_weight => 2) do
  #     @assignment_weight = build_assignment_weight
  #   end
  #   assert_must have_valid(:weight).when(2), @assignment_weight
  #   assert_wont have_valid(:weight).when(3), @assignment_weight
  # end
end
