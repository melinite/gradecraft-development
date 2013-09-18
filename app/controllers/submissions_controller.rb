class SubmissionsController < ApplicationController

  before_filter :ensure_staff?, :only=>[:index]
  include Canable::Enforcers

  def index
    @assignment = Assignment.find(params[:assignment_id])
    redirect_to @assignment
  end

  def show
    @title = "View Submission"
    @submission = Submission.find(params[:id])
    @assignment = Assignment.find(params[:assignment_id])
    if current_user.is_student?
      @user = current_user
      @badges = current_course.badges
      @assignments = current_course.assignments
    end
    enforce_view_permission(@submission)
  end

  def new
    @assignment = current_course.assignments.find(params[:assignment_id])
    @title = @assignment.name
    if current_user.is_staff?
      if @assignment.has_groups?
        @group = current_course.groups.find(params[:group_id])
      else
        @student = current_course.students.find(params[:student_id])
      end
    end
    if current_user.is_student?
      @user = current_user
      @badges = current_course.badges
      @assignments = current_course.assignments
      if @assignment.has_groups?
        @group = Group.find(params[:group_id])
      else
        @student = current_user
      end
    end
    @title = "New Submission for #{@assignment.name}"
    @submission = @assignment.submissions.new
  end

  def edit
    @assignment = current_course.assignments.find(params[:assignment_id])
    if current_user.is_staff?
      if @assignment.has_groups?
        @group = current_course.groups.find(params[:group_id])
      else
        @students = current_course.students
        @student = @students.find(params[:student_id])
      end
    end
    if current_user.is_student?
      @user = current_user
      @badges = current_course.badges
      @assignments = current_course.assignments
    end
    @groups = @assignment.groups
    @teams = current_course.teams
    @title = "Editing #{@student.name}'s Submission for #{@assignment.name}"
    @submission = Submission.find(params[:id])
  end

  def create
    @assignment = current_course.assignments.find(params[:assignment_id])
    @submission = @assignment.submissions.new(params[:submission])
    @submission.student = current_student if current_user.is_student?
    @submission.save
    respond_to do |format|
      if @submission.save
        if current_user.is_student?
          format.html { redirect_to dashboard_path, notice: "#{@assignment.name} was successfully submitted." }
          format.json { render json: @assignment, status: :created, location: @assignment }
        else
          format.html { redirect_to assignment_path(@assignment), notice: "#{@assignment.name} was successfully submitted." }
        end
      else
        format.html { render action: "new" }
        format.json { render json: @assignment.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @assignment = current_course.assignments.find(params[:assignment_id])
    @submission = @assignment.submissions.find(params[:id])
    respond_to do |format|
      if @submission.update_attributes(params[:submission])
        if current_user.is_student?
          format.html { redirect_to dashboard_path, notice: "#{@assignment.name} was successfully update." }
          format.json { render json: @assignment, status: :created, location: @assignment }
        else
          format.html { redirect_to assignment_path(@assignment), notice: "#{@assignment.name} was successfully update." }
        end
      else
        format.html { render action: "edit" }
        format.json { render json: @submission.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @assignment = Assignment.find(params[:assignment_id])
    @submission = Submission.find(params[:id])
    @submission.destroy
    respond_to do |format|
      format.html { redirect_to assignment_submissions_path(@assignment), notice: 'Submission was successfully deleted.' }
      format.json { head :ok }
    end
  end

  def find_student
    params.each do |name, value|
      if name =~ /(.+)_id$/
        return $1.classify.constantize.find(value)
      end
    end
    nil
  end

  def find_student
    params.each do |name, value|
      if name =~ /(.+)_id$/
        return $1.classify.constantize.find(value)
      end
    end
    nil
  end

end
