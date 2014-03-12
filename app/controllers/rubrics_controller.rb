class RubricsController < ApplicationController
  before_action :find_rubric, except: [:new, :create]

  def new
    @assignment = Assignment.find params[:assignment_id]
    @rubric = @assignment.build_rubric
    respond_with @rubric
  end

  def edit
    respond_with @rubric
  end

  def create
    @rubric = Rubric.create params[:rubric]
    respond_with @rubric
  end

  def destroy
    @rubric.destroy
    respond_with @rubric
  end

  def show
    respond_with @rubric
  end

  def update
    @rubric.update_attributes params[:rubric]
    respond_with @rubric
  end

  private
  def find_rubric
    @rubric = Rubric.find params[:id]
  end
end
