# TODO: This controller will need a major rewrite to handle editing multiple
# assignment weights at once.

class AssignmentWeightsController < ApplicationController
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
    @assignment_weight = @student.assignment_weights.find(params[:id])
    if current_user.is_student?
      enforce_view_permission(@assignment_weight)
    end
  end

  def new
    @assignment_type = current_course.assignment_types.find(params[:assignment_type_id])
    @assignment_types = current_course.assignment_types.where(:student_weightable => "true")
    @assignment_weight = @student.assignment_weights.new
    respond_with(user_assignment_weights_path)
  end

  def edit
    @assignment_type = current_course.assignment_types.find(params[:assignment_type_id])
    @assignment_types = current_course.assignment_types.where(:student_weightable => "true")
    @assignment_weight = StudentAssignmentTypeWeight.find(params[:id])
  end

  def create
    @assignment_weight = @student.assignment_weights.build(params[:assignment_weight])
    respond_with @assignment_weight
  end

  def update
    @assignment_weight = StudentAssignmentTypeWeight.find(params[:id])
    @assignment_weight.update_attributes(params[:assignment_weight])
    redirect_to dashboard_path
  end

  def destroy
    @assignment_weight = AssignmentWeight.find(params[:id])
    @assignment_weight.destroy
    redirect_to user_assignment_weights_path(@student)
  end

  private

  def set_student
    @student = User.find(params[:user_id])
  end
end
