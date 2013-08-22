class GradesController < ApplicationController
  respond_to :html, :json

  before_filter :ensure_staff?, :except=>[:self_log, :self_log_create]

  def index
    @assignment = Assignment.find(params[:assignment_id])
    redirect_to assignment_path(@assignment)
  end

  def show
    @grade = Grade.find(params[:id])
    @assignment = Assignment.find(params[:assignment_id])
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
    @assignment = Assignment.find(params[:assignment_id])
    @assignment_type = @assignment.assignment_type
    @grade = @assignment.grades.new
    #@grade.student = current_course.grades.where(params[:student_id])
    @badges = current_course.badges
    @score_levels = @assignment_type.score_levels
    @earned_badge = EarnedBadge.new
    #@earned_badges = current_course.badges.map do |b|
      #EarnedBadge.where(:badge_id => b.id, :earnable_id => @grade.id, :earnable_type => 'Grade').first || EarnedBadge.new(:badge_id => b.id, :earnable_id => @grade.id, :earnable_type => 'Grade')
    #end
    @teams = current_course.teams
    @groups = current_course.groups
    @students = current_course.users.students
    respond_with(@grade)
  end

  def edit
    @badges = current_course.badges
    @assignment = Assignment.find(params[:assignment_id])
    @assignment_type = @assignment.assignment_type
    @score_levels = @assignment_type.score_levels
    @students = current_course.users.students
    @teams = current_course.teams
    @groups = current_course.groups
    @grade = @assignment.grades.find(params[:id])
    #@earned_badges = current_course.badges.map do |b|
      #EarnedBadge.where(:badge_id => b.id, :earnable_id => @grade.id, :earnable_type => 'Grade').first || EarnedBadge.new(:badge_id => b.id, :earnable_id => @grade.id, :earnable_type => 'Grade')
    #end
    #@grade.student = current_course.grades.where(params[:student_id])
    respond_with @grade
  end

  def create
    @student = find_student
    @assignment = Assignment.find(params[:assignment_id])
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
        format.html { render action: "new" }
        format.json { render json: @grade.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @assignment = Assignment.find(params[:assignment_id])
    @grade = @assignment.grades.find(params[:id])
    @earnable = find_earnable
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
    @assignment = Assignment.find(params[:assignment_id])
    @grade = @assignment.grades.find(params[:id])
    @grade.destroy

    respond_to do |format|
      format.html { redirect_to assignment_path(@assignment), notice: "#{ @grade.student.name}'s #{@assignment.name} grade was successfully deleted." }
      format.json { head :ok }
    end
  end

  def self_log
    @assignment = Assignment.find(params[:assignment_id])
    @grade = @assignment.grades.create(params[:grade])
    @grade.student = current_course.grades.where(params[:student_id])
  end

  def self_log_create
    @student = find_student
    @assignment = Assignment.find(params[:assignment_id])
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
    @assignment = Assignment.find(params[:id])
    @assignment_type = @assignment.assignment_type
    @score_levels = @assignment_type.score_levels
    user_search_options = {}
    user_search_options['team_memberships.team_id'] = params[:team_id] if params[:team_id].present?
    @students = current_course.users.students.includes(:teams).where(user_search_options)
    @grades = @students.map do |s|
      @assignment.grades.where(:student_id => s).first || @assignment.grades.new(:student => s, :assignment => @assignment)
    end
  end

  def mass_update
    @student = find_student
    @assignment = Assignment.find(params[:id])
    @assignment.update_attributes(params[:assignment])
    respond_with @assignment
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

  def find_student
    params.each do |name, value|
      if name =~ /(.+)_id$/
        return $1.classify.constantize.find(value)
      end
    end
    nil
  end

  def find_earnable
    params.each do |name, value|
      if name =~ /(.+)_id$/
        return $1.classify.constantize.find(value)
      end
    end
    nil
  end

end
