class AssignmentTypeWeightsController < ApplicationController

  def mass_edit
    @assignment_types = current_course.assignment_types
    respond_with @form = AssignmentTypeWeightForm.new(current_student, current_course)
  end

  def mass_update
    @form = AssignmentTypeWeightForm.new(current_student, current_course)

    @form.update_attributes(student_params)
    @form.save
    if !form.save
      render :mass_edit
    end
  end

  private

  def student_params
    params.require(:student).permit(:assignment_type_weights_attributes => [:assignment_type_id, :weight])
  end

  def interpolation_options
    { weights_term: term_for(:weights) }
  end
end
