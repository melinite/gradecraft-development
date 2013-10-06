class AssignmentTypeWeightsController < ApplicationController

  def mass_edit
    if current_user.is_student?
      @user = current_user
      @badges = current_course.badges
      @assignments = current_course.assignments
      @assignment_types = current_course.assignment_types
      @by_assignment_type = @assignments.alphabetical.chronological.group_by(&:assignment_type)
      @sorted_teams = current_course.teams.order_by_high_score
      @scores_for_current_course = current_student.scores_for_course(current_course)
    end
    respond_with @form = AssignmentTypeWeightForm.new(current_student, current_course)
  end

  def mass_update
    @form = AssignmentTypeWeightForm.new(current_student, current_course)
    @form.update_attributes(student_params)
    if @form.save
      redirect_to dashboard_path
    else
      if current_user.is_student?
        @user = current_user
        @badges = current_course.badges
        @assignments = current_course.assignments
      end
      respond_with @form, action: :mass_edit
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
