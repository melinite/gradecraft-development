class AssignmentTypeWeightsController < ApplicationController

  def mass_edit
    @assignment_types = current_course.assignment_types
    if current_user.is_student?
      @user = current_user
      respond_with @form = AssignmentTypeWeightForm.new(current_student, current_course)
    elsif current_user.is_staff?
      @student = current_course.students.find(params[:student_id])
      respond_with @form = AssignmentTypeWeightForm.new(@student, current_course)
    end
  end

  def mass_update
    if current_user.is_student?
      @form = AssignmentTypeWeightForm.new(current_student, current_course)
    elsif current_user.is_staff?
      @form = AssignmentTypeWeightForm.new(@student, current_course)
    end
    @form.update_attributes(student_params)
    if @form.save
      if current_user.is_student?
        redirect_to dashboard_path
      else
        redirect_to choices_path
      end
    else
      if current_user.is_student?
        @user = current_user
      elsif current_user.is_staff?
        @student = current_course.students.find(params[:student_id])
      end
      render :mass_edit
    end
  end

  private

  def student_params
    debugger
    params.require(:student).permit(:assignment_type_weights_attributes => [:assignment_type_id, :weight])
  end

  def interpolation_options
    { weights_term: term_for(:weights) }
  end
end
