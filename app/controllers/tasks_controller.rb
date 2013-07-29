class TasksController < ApplicationController

  before_filter :ensure_staff?
  
  def index 
    @assignment = current_course.assignments.find(params[:assignment_id])
    @title = "#{@assignment.name} Task List"
    @tasks = @assignment.tasks
    respond_with(@tasks)
  end

  def show
    @asssignment = current_course.assignments.find(params[:assignment_id])
    @task = Task.find(params[:id])
    respond_with(@task)
  end

  def new
    @asssignment = current_course.assignments.find(params[:assignment_id])
    @tasks = current_course.assignments.tasks
    @title = "Create a New #{@assignment.name} Task"
    @button_title = "Create"
    @task = @assignment.tasks.create(params[:task])

  end

  def edit
    @asssignment = current_course.assignments.find(params[:assignment_id])
    @task = Task.find(params[:id])
    @title = "Edit #{@assignment.name} #{@task.name}"
    @button_title = "Update"
    respond_with(@task)
  end

  def create
    @asssignment = current_course.assignments.find(params[:assignment_id])
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
    @asssignment = current_course.assignments.find(params[:assignment_id])
    @task = @assignment.task.find(params[:id])
    @task.update_attributes(params[:task])
    respond_with @task
  end

  def destroy
    @asssignment = current_course.assignments.find(params[:assignment_id])
    @task = @assignment.ask.find(params[:task_id])
    @task.destroy
    
    respond_to do |format|
      format.html { redirect_to task_path(@task), notice: 'Grade Scheme Element was successfully deleted.' }
      format.json { head :ok }
    end
  end
end
