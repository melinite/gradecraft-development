class RubricsController < ApplicationController
  before_action :find_rubric, except: [:new, :create]
  after_action :respond_with_rubric

  def new
    @assignment = Assignment.find params[:assignment_id]
    @rubric = @assignment.rubric.build
  end

  def edit
  end

  def create
    @rubric = Rubric.create params[:rubric]
  end

  def destroy
    @rubric.destroy
  end

  def show
  end

  def update
    @rubric.update_attributes params[:rubric]
  end

  private
  def find_rubric
    @rubric = Rubric.find params[:id]
  end

  def respond_with_rubric
    respond_with @rubric
  end
end
