class ScoreLevelsController < ApplicationController

  before_filter :ensure_staff?

  def index
    @score_levels = ScoreLevel.all
  end

  def show
    @score_level = ScoreLevel.find(params[:id])
  end

  def new
    @score_level = ScoreLevel.new
  end

  def edit
    @score_level = current_course.score_levels.find(params[:id])
  end

  def create
    @score_level = ScoreLevel.new(params[:score_level])
    @score_level.save
  end

  def update
    @score_level = current_course.score_levels.find(params[:id])
    @score_level.update_attributes(params[:score_level])
  end

  def destroy
    @score_level = ScoreLevel.find(params[:id])
    @score_level.destroy
  end
end