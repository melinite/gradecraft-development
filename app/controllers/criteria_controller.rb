class CriteriaController < ApplicationController
  before_filter :set_rubric

  def index
    respond_with @criteria = @rubric.criteria
  end

  def show
    respond_with @criterium = @rubric.criteria.find(params[:id])
  end

  def new
    respond_with @criterium = @rubric.criteria.new(params.permit(:category))
  end

  def create
    @criterium = @rubric.criteria.new(criterium_params)
    @criterium.save
    respond_with @rubric, @criterium
  end

  def edit
    respond_with @criterium = @rubric.criteria.find(params[:id])
  end

  def update
    @criterium = @rubric.criteria.find(params[:id])
    @criterium.update_attributes(criterium_params)
    respond_with @rubric, @criterium
  end

  def destroy
    respond_with @criterium = @rubric.criteria.find(params[:id])
    @criterium.destroy
    respond_with @rubric, @criterium
  end

  private

  def criterium_params
    params.require(:criterium).permit!
  end

  def set_rubric
    @rubric = current_course.rubrics.find params[:rubric_id]
  end
end
