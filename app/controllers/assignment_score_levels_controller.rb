class AssignmentScoreLevelsController < ApplicationController

  before_filter :ensure_staff?

  def create
    @assignment_score_level = current_course.assignment_score_levels.new(params[:assignment_score_level])
    @assignment_score_level.save
  end

  def update
    @assignment_score_level = current_course.assignment_score_levels.find(params[:id])
    @assignment_score_level.update_attributes(params[:assignment_score_level])
    respond_with @assignment_score_level
  end

  def destroy
    @assignment_score_level = current_course.assignment_score_levels.find(params[:id])
    @assignment_score_level.destroy
    respond_with @assignment_score_level
  end
end