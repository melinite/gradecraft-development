class SubmissionsController < ApplicationController

  before_filter :ensure_staff?, :only=>[:index]
<<<<<<< HEAD
  include Canable::Enforcers
=======
  before_filter :set_assignment
>>>>>>> Make speed grading nav work

  def index
    @submissions = @assignment.submissions.where(params[:assignment_id])
  end

  def show
    @title = "View Submission"
    @submission = Submission.find(params[:id])
<<<<<<< HEAD
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
    @title = "Submit #{@assignment.name}"
=======
#     if current_user.is_student?
#       enforce_view_permission(@submission)
#     end
#     @assignment_type = @assignment.assignment_type
#
#     if current_user.is_staff?
#       @student = params[:student_id]
#       @score_levels = @assignment_type.score_levels
#     end
  end

  def new
    @title = "Submit #{@assignment.name}"
    @student = find_student
    @student = current_course.users.find(params[:id])
>>>>>>> Make speed grading nav work
    @submission = @assignment.submissions.new
  end

  def create
    @submission = @assignment.submissions.new(params[:submission])
    @submission.student = current_student
    @submission.save
    location = current_user.is_student? ? dashboard_path : @assignment
    notice = "#{@assignment.name} was successfully submitted."
    respond_with @submission, location: location, notice: notice
  end

  def edit
<<<<<<< HEAD
    @assignment = current_course.assignments.find(params[:assignment_id])
    if current_user.is_staff?
      if @assignment.has_groups?
        @group = current_course.groups.find(params[:group_id])
        @title = "Editing #{@group.name}'s Submission for #{@assignment.name}"
      else
        @student = current_course.students.find(params[:student_id])
        @title = "Editing #{@student.name}'s Submission for #{@assignment.name}"
      end
    end
    if current_user.is_student?
      @title = "Editing My Submission for #{@assignment.name}"
      @user = current_user
      @badges = current_course.badges
      @assignments = current_course.assignments
    end
=======
    @students = current_course.users.students
>>>>>>> Make speed grading nav work
    @groups = @assignment.groups
    @teams = current_course.teams
    @submission = Submission.find(params[:id])
  end

<<<<<<< HEAD
  def create
    @assignment = current_course.assignments.find(params[:assignment_id])
    @submission = @assignment.submissions.new(params[:submission])
    @submission.student = current_student if current_user.is_student?
    @submission.save
    respond_to do |format|
      if @submission.save
        if current_user.is_student?
          format.html { redirect_to assignment_submission_path(@assignment, @submission), notice: "#{@assignment.name} was successfully submitted." }
          format.json { render json: @assignment, status: :created, location: @assignment }
        else
          format.html { redirect_to assignment_path(@assignment), notice: "#{@assignment.name} was successfully submitted." }
        end
        user = { name: "#{@submission.student.first_name}", email: "#{@submission.student.email}" }
        submission = { name: "#{@submission.assignment.name}", time: "#{@submission.created_at}" }
        NotificationMailer.successful_submission(user, submission).deliver
      else
        format.html { render action: "new" }
        format.json { render json: @assignment.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @assignment = current_course.assignments.find(params[:assignment_id])
=======
  def update
>>>>>>> Make speed grading nav work
    @submission = @assignment.submissions.find(params[:id])
    respond_to do |format|
      if @submission.update_attributes(params[:submission])
        if current_user.is_student?
          format.html { redirect_to assignment_submission_path(@assignment, @submission), notice: "Your submission for #{@assignment.name} was successfully updated." }
          format.json { render json: @assignment, status: :created, location: @assignment }
        else
          format.html { redirect_to assignment_path(@assignment), notice: "#{@assignment.name} was successfully updated." }
        end
      else
        format.html { render action: "edit" }
        format.json { render json: @submission.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @submission = Submission.find(params[:id])
    @submission.destroy
    respond_to do |format|
      format.html { redirect_to assignment_submissions_path(@assignment), notice: 'Submission was successfully deleted.' }
      format.json { head :ok }
    end
  end

  private

  def set_assignment
    @assignment = current_course.assignments.find(params[:assignment_id])
  end
end
