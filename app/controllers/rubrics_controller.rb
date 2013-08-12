class RubricsController < ApplicationController
  def index
    respond_with @rubrics = current_course.rubrics
  end

  def show
    respond_with @rubric = current_course.rubrics.find(params[:id])
  end

  def new
    respond_with @rubric = current_course.rubrics.new
  end

  def create
    @rubric = current_course.rubric.new(params[:rubric])
    @rubric.save
    respond_with @rubric
  end

  def edit
    @rubric = current_course.rubrics.find(params[:id])
  end

  def update
    @rubric = current_course.rubrics.find(params[:id])
    @rubric.update_attributes(params[:rubric])
    respond_with @rubric
  end

  def destroy
    @rubric = current_course.rubrics.find(params[:id])
    @rubric.destroy
    respond_with @rubric
  end
end
