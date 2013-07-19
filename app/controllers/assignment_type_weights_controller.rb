# TODO: This controller will need a major rewrite to handle editing multiple
# assignment weights at once.

class AssignmentTypeWeightsController < ApplicationController
  before_filter :ensure_staff?, :only => :index
  before_filter :set_student

  def index
    @title = "View all #{current_course.multiplier_term}"
    @assignment_weights = @student.assignment_weights
    @assignment_types = current_course.assignment_types
    respond_with @assignment_weights
  end

  def show
    @title = "User Set Kapital"
    @student_assignment_type_weight = @student.student_assignment_type_weights.find(params[:id])
    if current_user.is_student?
      enforce_view_permission(@student_assignment_type_weight)
    end
  end

  def new
    @assignment_type = AssignmentType.find(params[:assignment_type_id])
    @assignment_types = current_course.assignment_types.where(:student_weightable => "true")
    @student_assignment_type_weight = @student.student_assignment_type_weights.new
    respond_with(user_student_assignment_type_weights_path)
  end

  def edit
    @assignment_type = AssignmentType.find(params[:assignment_type_id])
    @assignment_types = current_course.assignment_types.where(:student_weightable => "true")
    @student_assignment_type_weight = StudentAssignmentTypeWeight.find(params[:id])
  end

  def create
    @assignment_weight = @student.student_assignment_type_weights.build(params[:student_assignment_type_weight])
    respond_with @assignment_weight
  end

  def update
    @student_assignment_type_weight = StudentAssignmentTypeWeight.find(params[:id])
    @student_assignment_type_weight.update_attributes(params[:student_assignment_type_weight])
    redirect_to dashboard_path
  end

  def destroy
    @assignment_type_weight = StudentAssignmentTypeWeight.find(params[:id])
    @student_assignment_type_weight.destroy
    redirect_to user_student_assignment_type_weights_path(@student)
  end

  private

  def set_student
    @student = User.find(params[:user_id])
  end
end
