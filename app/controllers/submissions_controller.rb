class SubmissionsController < ApplicationController

  before_filter :ensure_staff?, :only=>[:index]

  def index
    @assignment = Assignment.find(params[:assignment_id])
    @title = "View All Submissions for #{@assignment.name}"
    @submissions = @assignment.submissions.where(params[:assignment_id])
  end

  def show
    @title = "View Submission"
    @assignment = Assignment.find(params[:assignment_id])
    @submission = Submission.find(params[:id])
    if current_user.is_student?
      enforce_view_permission(@submission)
    end
    @assignment_type = @assignment.assignment_type

    if current_user.is_staff?
      @student = params[:student_id]
      @score_levels = @assignment_type.score_levels
    end
    respond_with(@grade)
  end

  def new
    @assignment = Assignment.find(params[:assignment_id])
    @title = "Submit #{@assignment.name}"
    @student = current_course.users.find(params[:id])
    @submission = @assignment.submissions.new
    @submission.submission_files.build
    @groups = @assignment.groups
    @teams = current_course.teams
    @students = @users.students
  end

  def edit
    @assignment = Assignment.find(params[:assignment_id])
    @students = current_course.users.students
    @groups = @assignment.groups
    @teams = current_course.teams
    @title = "Edit Submission for #{@assignment.name}"
    @submission = Submission.find(params[:id])
  end

  def create
    @assignment = Assignment.find(params[:assignment_id])
    @submission = @assignment.submissions.build(params[:submission])
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
    @assignment = Assignment.find(params[:assignment_id])
    @submission = @assignment.submissions.find(params[:id])
    respond_to do |format|
      if @submission.update_attributes(params[:submission])
        format.html { redirect_to dashboard_path, notice: "Your #{@assignment.name} was successfully updated." }
        format.json { head :ok }
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
