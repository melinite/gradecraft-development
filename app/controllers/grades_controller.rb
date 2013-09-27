class GradesController < ApplicationController
  respond_to :html, :json

  before_filter :ensure_staff?, :except => [:self_log, :self_log_create]
  before_filter :set_assignment

  def index
    redirect_to assignment_path(@assignment)
  end

  def show
    @grade = @assignment.grades.find(params[:id])
  end

  def gradebook
    @assignments = current_course.assignments.sort_by &:id
    @students = current_course.users.students.includes(:grades)
    respond_to do |format|
      format.html
      format.json { render json: @assignments }
      format.csv { send_data @assignments.to_csv }
      format.xls { send_data @assignments.to_csv(col_sep: "\t") }
    end
  end

  def new
    @assignment_type = @assignment.assignment_type
    @students = current_course.students
    @score_levels = @assignment_type.score_levels
    @student = current_course.students.find(params[:student_id])
    @groups = current_course.groups
    @title = "Grading #{@student.name}'s #{@assignment.name}"
    @grade = @student.grades.new(assignment: @assignment)
  end

  def edit
    @badges = current_course.badges
    @assignment_type = @assignment.assignment_type
    @score_levels = @assignment_type.score_levels
    @grade = @assignment.grades.find(params[:id])
    @students = current_course.students
    @student = @students.find(params[:student_id])
    @teams = current_course.teams
    @groups = current_course.groups
    @title = "Editing #{@student.name}'s Grade for #{@assignment.name}"
    respond_with @grade
  end

  def create
    @assignment = current_course.assignments.find(params[:assignment_id])
    @grade = @assignment.grades.build(params[:grade])
    @grade.graded_by = current_user
    @grade.save
    @student = find_student
    @students = current_course.users.students
    @grade = @student.grades.build(params[:grade])
    @earnable = find_earnable
    @badges = current_course.badges
    @earned_badge = EarnedBadge.new(params[:earned_badge])
    respond_to do |format|
      if @grade.save
        format.html { redirect_to @assignment, notice: 'Grade was successfully created.' }
        format.json { render json: @grade, status: :created, location: @grade }
      else
        format.html { render action: "new", notice: 'Oh no! We cannot submit this grade.' }
        format.json { render json: @grade.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @grade = @assignment.grades.find(params[:id])
    @student = find_student
    @badges = current_course.badges
    respond_to do |format|
      if @grade.update_attributes(params[:grade])
        format.html { redirect_to @assignment, notice: 'Grade was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @grade.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @grade = @assignment.grades.find(params[:id])
    @grade.destroy

    respond_to do |format|
      format.html { redirect_to assignment_path(@assignment), notice: "#{ @grade.student.name}'s #{@assignment.name} grade was successfully deleted." }
      format.json { head :ok }
    end
  end

  def self_log
    @grade = @assignment.grades.create(params[:grade])
    @grade.student = current_course.grades.where(params[:student_id])
  end

  def self_log_create
    @student = find_student
    @grade = @student.grades.build(params[:grade])
    respond_to do |format|
      if @grade.save
        format.html { redirect_to dashboard_path, notice: 'Thank you for logging your grade!' }
      else
        format.html { redirect_to dashboard_path, notice: "We're sorry, this grade could not be added." }
      end
    end
  end

  def mass_edit
    @title = "Quick Grade #{@assignment.name}"
    @assignment_type = @assignment.assignment_type
    @score_levels = @assignment_type.score_levels
    @team = current_course.teams.find_by(id: params[:team_id]) if params[:team_id]
    user_search_options = {}
    user_search_options['team_memberships.team_id'] = params[:team_id] if params[:team_id].present?
    @students = current_course.students.includes(:teams).where(user_search_options).alpha
    @grades = @students.map do |s|
      @assignment.grades.where(:student_id => s).first || @assignment.grades.new(:student => s, :assignment => @assignment)
    end
  end

  def mass_update
    @student = find_student
    @assignment.update_attributes(params[:assignment])
    respond_with @assignment
  end

  def speed_edit
    self.current_student = current_course_data.students.first unless current_student
  end

  def speed_update
    students = current_course.students.alpha
    @student = students.find(params.fetch :student_id)
    @next = students.next(@student)
    @previous = students.previous(@student)
    if @assignment.update_attributes(params[:assignment])
      respond_with @assignment, location: speed_grade_assignment_path(@assignment, student_id: @next)
    else
      render :speed_edit
    end
  end

  def edit_status
    @assignment = Assignment.find(params[:assignment_id])
    @title = "#{@assignment.name} Grade Statuses"
    @grades = Grade.find(params[:grade_ids])
  end

  def update_status
    @assignment = Assignment.find(params[:assignment_id])
    @grades = Grade.find(params[:grade_ids])
    @grades.each do |grade|
      grade.update_attributes!(params[:grade].reject { |k,v| v.blank? })
    end
    flash[:notice] = "Updated grades!"
    redirect_to assignment_path(@assignment)
  end

  private

  def set_assignment
    @assignment = if params[:assignment_id]
      current_course.assignments.find(params[:assignment_id])
    else
      current_course.assignments.find(params[:id])
    end
  end
end
