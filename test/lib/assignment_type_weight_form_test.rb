require 'test_helper'

class AssignmentTypeWeightFormTest < ActiveSupport::TestCase
  include ValidAttribute::Method

  test "adds an error when assignment weight exceeds course total assignment weight" do
    @form = AssignmentTypeWeightForm.new(student, course)

    weight = AssignmentTypeWeight.new(student, create_assignment_type)
    weight.weight = 2
    @form.assignment_type_weights << weight

    assert @form.valid?

    weight = AssignmentTypeWeight.new(student, assignment_type)
    weight.weight = 1
    @form.assignment_type_weights << weight

    refute @form.valid?
  end

  test "adds an error when assignment weight is less than course total assignment weight" do
    @form = AssignmentTypeWeightForm.new(student, course)

    weight = AssignmentTypeWeight.new(student, create_assignment_type)
    weight.weight = 1
    @form.assignment_type_weights << weight

    refute @form.valid?

    weight.weight = 2

    assert @form.valid?
  end

  def course
    @course = create_course(total_assignment_weight: 2)
  end
end
