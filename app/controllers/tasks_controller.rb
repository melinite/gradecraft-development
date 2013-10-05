class TasksController < ApplicationController

  before_filter :ensure_staff?

  before_filter :load_assignment

  def index
    redirect_to @assignment
  end

  def show
    @task = Task.find(params[:id])
  end

  def new
    @title = "Create a New #{@assignment.name} Task"
    @task = @assignment.tasks.new
  end

  def edit
    @task = Task.find(params[:id])
    @title = "Edit #{@assignment.name} Task"
    @button_title = "Update"
  end

  def create
    @task = @assignment.tasks.new(params[:task])
    if @task.save
      redirect_to @assignment, notice: "Your task has been created."
    else
      render :new
    end
  end

  def update
    @assignment = Assignment.find(params[:assignment_id])
    @task = @assignment.tasks.find(params[:id])
    @task.update_attributes(params[:task])
    respond_with @assignment
  end

  def destroy
    @assignment = Assignment.find(params[:assignment_id])
    @task = @assignment.tasks.find(params[:id])
    @task.destroy

    respond_to do |format|
      format.html { redirect_to assignment_tasks_path(@assignment), notice: 'Task was successfully deleted.' }
      format.json { head :ok }
    end
  end

  private

  def load_assignment
    klass = [Assignment, Badge].detect { |c| params["#{c.name.underscore}_id"]}
    @assignment = klass.find(params["#{klass.name.underscore}_id"])
  end

end
