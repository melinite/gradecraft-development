class AssignmentTypeWeightsController < ApplicationController
  before_filter :set_student

  def mass_edit
    if current_user.is_student?
      @user = current_user
      @badges = current_course.badges
      @assignments = current_course.assignments
    end
    respond_with @form = AssignmentTypeWeightForm.new(@student, current_course)
  end

  def mass_update
    @form = AssignmentTypeWeightForm.new(@student, current_course)
    @form.update_attributes(student_params)
    if @form.save
      redirect_to dashboard_path
    else
      respond_with @form, action: :mass_edit
    end
  end

  private

  def student_params
    params.require(:student).permit(:assignment_type_weights_attributes => [:assignment_type_id, :weight])
  end

  def set_student
    if current_user.is_staff?
      @student = User.find(params.fetch[:user_id])
    else
      @student = current_user
    end
  end

  def interpolation_options
    { weights_term: term_for(:weights) }
  end
end
