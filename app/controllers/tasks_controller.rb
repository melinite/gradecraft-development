class TasksController < ApplicationController

  before_filter :ensure_staff?
  
  def index 
    @assignment = current_course.assignments.find(params[:assignment_id])
    @title = "#{@assignment.name} Task List"
    @tasks = @assignment.tasks
    respond_with(@tasks)
  end

  def show
    @assignment = current_course.assignments.find(params[:assignment_id])
    @task = Task.find(params[:id])
    respond_with(@task)
  end

  def new
    @assignments = current_course.assignments
    @assignment = Assignment.find(params[:assignment_id])
    @title = "Create a New #{@assignment.name} Task"
    @button_title = "Create"
    @task = @assignment.tasks.create(params[:task])

  end

  def edit
    @assignment = current_course.assignments.find(params[:assignment_id])
    @task = Task.find(params[:id])
    @title = "Edit #{@assignment.name} Task"
    @button_title = "Update"
    respond_with(@task)
  end

  def create
    @assignment = current_course.assignments.find(params[:assignment_id])
    @task = @assignment.new(params[:task])
    respond_to do |format|
      if @task.save
        format.html { redirect_to @task, notice: 'Task successfully created.' }
        format.json { render json: @task, status: :created, location: @task }
      else
        format.html { render action: "new" }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
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
end
