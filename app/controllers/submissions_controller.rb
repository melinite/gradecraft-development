class SubmissionsController < ApplicationController

  before_filter :ensure_staff?, :only=>[:index]

  include Canable::Enforcers
  helper UploadsHelper

  def index
    @assignment = current_course.assignments.find(params[:assignment_id])
    redirect_to @assignment
  end

  def show
    @assignment = current_course.assignments.find(params[:assignment_id])
    @submission = @assignment.submissions.find(params[:id])
    #@grade = @assignment.grades.find(@submission)
    redirect_to assignment_grade_path(@assignment, @submission.student)
  end

  def new
    session[:return_to] = request.referer
    @assignment = current_course.assignments.find(params[:assignment_id])
    @title = @assignment.name
    if current_user.is_staff?
      if @assignment.has_groups?
        @group = current_course.groups.find(params[:group_id])
      else
        @student = current_student
      end
    end
    if current_user.is_student?
      @user = current_user
      if @assignment.has_groups?
        @group = current_course.groups.find(params[:group_id])
      else
        @student = current_user
      end
    end
    @title = "Submit #{@assignment.name}"
    @submission = @assignment.submissions.new
  end

  def edit
    session[:return_to] = request.referer
    @assignment = current_course.assignments.find(params[:assignment_id])
    @submission = current_course.submissions.find(params[:id])
    @student = @submission.student
    if current_user.is_staff?
      if @assignment.has_groups?
        @group = current_course.groups.find(params[:group_id])
        @title = "Editing #{@group.name}'s Submission "
      else
        @title = "Editing #{@submission.student.name}'s Submission"
      end
    end
    if current_user.is_student?
      @title = "Editing My Submission for #{@assignment.name}"
      @user = current_user
      enforce_view_permission(@submission)
    end
    @groups = @assignment.groups
    @teams = current_course.teams
  end

  def create
    @assignment = current_course.assignments.find(params[:assignment_id])
    @submission = @assignment.submissions.new(params[:submission])
    @submission.student = current_student if current_user.is_student?
    respond_to do |format|
      self.check_uploads
      if @submission.save
        if current_user.is_student?
          format.html { redirect_to assignment_grade_path(@assignment, :student_id => current_user), notice: "#{@assignment.name} was successfully submitted." }
          format.json { render json: @assignment, status: :created, location: @assignment }
        else
          format.html { redirect_to session.delete(:return_to), notice: "#{@assignment.name} was successfully submitted." }
        end
        if @assignment.is_individual? && current_user.is_student?
          user = { name: "#{@submission.student.first_name}", email: "#{@submission.student.email}" }
          submission = { name: "#{@submission.assignment.name}", time: "#{@submission.created_at}" }
          course = { courseno: "#{current_course.courseno}" }
          NotificationMailer.successful_submission(user, submission, course).deliver
        end
      elsif @submission.errors[:link].any?
        format.html { redirect_to new_assignment_submission_path(@assignment, @submission), notice: "Please provide a valid link for #{@assignment.name} submissions." }
      else
        format.html { redirect_to new_assignment_submission_path(@assignment, @submission), notice: "#{@assignment.name} was not successfully submitted! Please try again." }
        format.json { render json: @assignment.errors, status: :unprocessable_entity }
      end
    end
  end

  def check_uploads
    if params[:submission][:submission_files_attributes]["0"][:filepath].empty?
      params[:submission].delete(:submission_files_attributes)
      @submission.submission_files.destroy_all
    end
  end

  def update
    @assignment = current_course.assignments.find(params[:assignment_id])
    @submission = @assignment.submissions.find(params[:id])
    respond_to do |format|
      self.check_uploads
      if @submission.update_attributes(params[:submission])
        if current_user.is_student?
          format.html { redirect_to assignment_grade_path(@assignment, :student_id => current_user), notice: "Your submission for #{@assignment.name} was successfully updated." }
          format.json { render json: @assignment, status: :created, location: @assignment }
        else
          format.html { redirect_to session.delete(:return_to), notice: "#{@assignment.name} was successfully updated." }
        end
      elsif @submission.errors[:link].any?
        format.html { redirect_to edit_assignment_submission_path(@assignment, @submission), notice: "Please provide a valid link for #{@assignment.name} submissions." }
      else
        format.html { redirect_to edit_assignment_submission_path(@assignment, @submission), notice: "#{@assignment.name} was not successfully submitted! Please try again." }
        format.json { render json: @submission.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @assignment = current_course.assignments.find(params[:assignment_id])
    @submission = current_course.submissions.find(params[:id])
    @submission.destroy
    respond_to do |format|
      format.html { redirect_to assignment_submissions_path(@assignment) }
      format.json { head :ok }
    end
  end
end
