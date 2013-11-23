class TasksController < ApplicationController

  before_filter :ensure_staff?

  def index
    @assignment = find_assignment
    redirect_to @assignment
  end

  def show
    @assignment = find_assignment
    @task = @assignment.tasks.find(params[:id])
  end

  def new
    @assignment = find_assignment
    @title = "Create a New #{@assignment.name} Task"
    @task = @assignment.tasks.new
  end

  def edit
    @assignment = find_assignment
    @task = @assignment.tasks.find(params[:id])
    @title = "Edit #{@assignment.name} Task"
    @button_title = "Update"
  end

  def create
    @assignment = find_assignment
    @task = @assignment.tasks.new(params[:task])
    if @task.save
      redirect_to @assignment, notice: "Your task has been created."
    else
      render :new
    end
  end

  def update
    @assignment = find_assignment
    @task = @assignment.tasks.find(params[:id])
    @task.update_attributes(params[:task])
    respond_with @assignment
  end

  def destroy
    @assignment = find_assignment
    @task = @assignment.tasks.find(params[:id])
    @task.destroy

    respond_with @assignment
  end

  private

  def find_assignment
    params.each do |name, value|
      if name =~ /(.+)_id$/
        return $1.classify.constantize.find(value)
      end
    end
    nil
  end

end
