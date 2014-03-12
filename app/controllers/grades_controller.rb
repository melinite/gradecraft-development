class GradesController < ApplicationController
  respond_to :html, :json

  before_filter :set_assignment, only: [:show, :edit, :update, :destroy]
  before_filter :ensure_staff?, :except => [:self_log, :predict_score, :show]
  before_filter :ensure_student?, only: [:predict_score]

  def show
    @assignment = current_course.assignments.find(params[:assignment_id])
    if current_user.is_student? 
      redirect_to @assignment
    end
    if @assignment.has_groups? && current_user.is_staff?
      @group = @assignment.groups.find(params[:group_id])
    elsif @assignment.has_groups? && current_user.is_student?
      @grade = current_student_data.grade_for_assignment(@assignment)
    end
  end

  def edit
    session[:return_to] = request.referer
    redirect_to @assignment and return unless current_student.present?
    @grade = current_student_data.grade_for_assignment(@assignment)
    @score_levels = @assignment.score_levels.order_by_value
    @assignment_score_levels = @assignment.assignment_score_levels.order_by_value
  end

  def update
    redirect_to @assignment and return unless current_student.present?
    @grade = current_student_data.grade_for_assignment(@assignment)
    @grade.update_attributes(params[:grade])
    
    if @assignment.notify_released? && @grade.is_released?
      NotificationMailer.grade_released(@grade.id).deliver
    end
    redirect_to session[:return_to]
  end

  def destroy
    redirect_to @assignment and return unless current_student.present?
    @grade = current_student_data.grade_for_assignment(@assignment)
    @grade.destroy

    redirect_to assignment_path(@assignment), notice: "#{ @grade.student.name}'s #{@assignment.name} grade was successfully deleted."
  end

  # Allows students to self log grades for a particular assignment if the instructor has turned that feature on - currently only used to log attendance
  def self_log
    @assignment = current_course.assignments.find(params[:id])
    if @assignment.open?
      @grade = current_student_data.grade_for_assignment(@assignment)
      @grade.raw_score = params[:present] == 'true' ? @assignment.point_total : 0
      @grade.status = "Graded"
      respond_to do |format|
        if @grade.save
          format.html { redirect_to dashboard_path, notice: 'Thank you for logging your grade!' }
        else
          format.html { redirect_to dashboard_path, notice: "We're sorry, this grade could not be added." }
        end
      end
    else
      format.html { redirect_to dashboard_path, notice: "We're sorry, this assignment is no longer open." }
    end
  end

  # Students predicting the score they'll get on an assignent using the grade predictor 
  def predict_score
    @assignment = current_course.assignments.find(params[:id])
    raise "Cannot set predicted score if grade status is 'Graded' or 'Released'" if current_student_data.grade_released_for_assignment?(@assignment)
    @grade = current_student_data.grade_for_assignment(@assignment)
    @grade.predicted_score = params[:predicted_score]
    respond_to do |format|
      format.json do
        if @grade.save
          render :json => @grade
        else
          render :json => { errors:  @grade.errors.full_messages }, :status => 400
        end
      end
    end
  end

  # Quickly grading a single assignment for all students
  def mass_edit
    @assignment = current_course.assignments.find(params[:id])
    @title = "Quick Grade #{@assignment.name}"
    @assignment_type = @assignment.assignment_type
    @score_levels = @assignment_type.score_levels.order_by_value
    @assignment_score_levels = @assignment.assignment_score_levels.order_by_value
    @team = current_course.teams.find_by(id: params[:team_id]) if params[:team_id]
    user_search_options = {}
    user_search_options['team_memberships.team_id'] = params[:team_id] if params[:team_id].present?
    @students = current_course.students.includes(:teams).where(user_search_options).alpha
    @grades = @students.alpha.order_by_auditing.map do |s|
      @assignment.grades.where(:student_id => s).first || @assignment.grades.new(:student => s, :assignment => @assignment, :graded_by_id => current_user)
    end
  end

  def mass_update
    @assignment = current_course.assignments.find(params[:id])
    if @assignment.update_attributes(params[:assignment])
      if !params[:team_id].blank?
        redirect_to assignment_path(@assignment, :team_id => params[:team_id])
      else
        respond_with @assignment
      end
    else
      @title = "Quick Grade #{@assignment.name}"
      @assignment_type = @assignment.assignment_type
      @score_levels = @assignment_type.score_levels
      @assignment_score_levels = @assignment.assignment_score_levels
      if params[:group]
        user_search_options = {}
        user_search_options['team_memberships.team_id'] = params[:team_id] if params[:team_id].present?
        @students = current_course.users.students.includes(:teams).where(user_search_options).alpha
      else
        @group = @assignment.groups.find(params[:group_id])
        @students = @group.students
      end
      @grades = @students.map do |s|
        @assignment.grades.where(:student_id => s).first || @assignment.grades.new(:student => s, :assignment => @assignment, :graded_by_id => current_user)
      end
      respond_with @assignment, :template => "grades/mass_edit"
    end
  end

  # Grading an assignment for a whole group
  def group_edit
    @assignment = current_course.assignments.find(params[:id])
    @group = @assignment.groups.find(params[:group_id])
    @title = "Grading #{@group.name}'s #{@assignment.name}"
    @assignment_type = @assignment.assignment_type
    @score_levels = @assignment_type.score_levels
    @assignment_score_levels = @assignment.assignment_score_levels
    @grades = @group.students.map do |student|
      @assignment.grades.where(:student_id => student).first || @assignment.grades.new(:student => student, :assignment => @assignment, :graded_by_id => current_user, :status => "Graded")
    end
    @submit_message = "Submit Grades"
  end

  # Changing the status of a grade - allows instructors to review "Graded" grades, before they are "Released" to students
  def edit_status
    @assignment = current_course.assignments.find(params[:id])
    @title = "#{@assignment.name} Grade Statuses"
    @grades = @assignment.grades.find(params[:grade_ids])
  end

  def update_status
    @assignment = current_course.assignments.find(params[:id])
    @grades = @assignment.grades.find(params[:grade_ids])
    @grades.each do |grade|
      grade.update_attributes!(params[:grade].reject { |k,v| v.blank? })
      if @assignment.notify_released? && grade.released
        NotificationMailer.grade_released(grade.id).deliver
      end
    end
    flash[:notice] = "Updated grades!"
    redirect_to assignment_path(@assignment)
  end

  #upload grades for an assignment
  def import
    @assignment = current_course.assignments.find(params[:id])
  end

  def upload
    @assignment = current_course.assignments.find(params[:id])
    @students = current_course.students

    require 'csv'

    if params[:file].blank?
      flash[:notice] = "File missing"
      redirect_to assignment_path(@assignment)
    else
      CSV.foreach(params[:file].tempfile, :headers => true, :encoding => 'ISO-8859-1') do |row|
        @students.each do |student|
          if student.username == row[2] && row[3].present?
            if student.grades.where(:assignment_id => @assignment).present?
              @assignment.all_grade_statuses_grade_for_student(student).tap do |grade|
                grade.raw_score = row[3].to_i
                grade.feedback = row[5]
                grade.status = "Graded"
                grade.save!
              end
            else
              @assignment.grades.create! do |g|
                g.assignment_id = @assignment.id
                g.student_id = student.id
                g.raw_score = row[3].to_i
                g.feedback = row[5]
                g.status = "Graded"
              end
            end
          end
        end
      end
    redirect_to assignment_path(@assignment), :notice => "Upload successful"
    end
  end

  private

  def set_assignment
    @assignment = current_course.assignments.find(params[:assignment_id]) if params[:assignment_id]
  end
end
