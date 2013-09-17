class CriteriaLevelsController < ApplicationController
  def index
    @criteria_levels = current_course.criteria_level.all
    respond_with(@criteria_levels)
  end

  def show
    @criteria_level = current_course.criteria_level.find(params[:id])
    respond_with(@criteria_level)
  end

  def new
    @criteria_level = current_course.criteria_level.new
    respond_with(@criteria_level)
  end

  def edit
    @criteria_level = current_course.criteria_level.find(params[:id])
  end

  def create
    @criteria_level = current_course.criteria_level.new(params[:criteria_level])
    @criteria_level.save
    respond_with(@criteria_level)
  end

  def update
    @criteria_level = current_course.criteria_level.find(params[:id])
    @criteria_level.update_attributes(params[:criteria_level])
    respond_with(@criteria_level)
  end

  def destroy
    @criteria_level = current_course.criteria_level.find(params[:id])
    @criteria_level.destroy
    respond_with(@criteria_level)
  end
end
