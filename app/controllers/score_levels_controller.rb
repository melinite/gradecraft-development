class ScoreLevelsController < ApplicationController

  before_filter :ensure_staff?

  def index
    @score_levels = current_course.score_levels
  end

  def show
    @score_level = current_course.score_levels.find(params[:id])
  end

  def new
    @score_level = current_course.score_levels.new
  end

  def edit
    @score_level = current_course.score_levels.find(params[:id])
  end

  def create
    @score_level = current_course.score_levels.new(params[:score_level])
    @score_level.save
    respond_with @score_level
  end

  def update
    @score_level = current_course.score_levels.find(params[:id])
    @score_level.update_attributes(params[:score_level])
    respond_with @score_level
  end

  def destroy
    @score_level = current_course.score_levels.find(params[:id])
    @score_level.destroy
    respond_with @score_level
  end
end