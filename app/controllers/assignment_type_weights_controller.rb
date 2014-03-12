class AssignmentTypeWeightsController < ApplicationController

  # Students set their assignment type weights all at once 
  def mass_edit
    @assignment_types = current_course.assignment_types
    respond_with @form = AssignmentTypeWeightForm.new(current_student, current_course)
  end

  def mass_update
    @form = AssignmentTypeWeightForm.new(current_student, current_course)

    @form.update_attributes(student_params)

    if @form.save
      redirect_to current_user.is_student? ? dashboard_path : multiplier_choices_path
    else
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
