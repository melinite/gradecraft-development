class StudentsController < ApplicationController
  helper_method :predictions

  respond_to :html, :json

  before_filter :ensure_staff?, :except=> [:timeline, :predictor, :grading_philosophy, :badges, :teams, :syllabus]

  def index
    @title = "#{current_course.user_term} Roster"
    @team = current_course.teams.find_by(id: params[:team_id]) if params[:team_id]
    user_search_options = {}
    user_search_options['team_memberships.team_id'] = params[:team_id] if params[:team_id].present?
    @auditing = current_course.students.auditing.includes(:teams).where(user_search_options).alpha
  end

  def timeline
    @scores_for_current_course = current_student.scores_for_course(current_course)
    if current_course.team_challenges?
      @events = current_course_data.assignments.timelineable.to_a + current_course.challenges
    else
      @events = current_course_data.timelineable.to_a
    end
  end

  def export
    @auditing = current_course.students.auditing
    @students = current_course.students.being_graded respond_to do |format|
      format.html
      format.json { render json: @students.where("first_name like ?", "%#{params[:q]}%") }
      format.csv { send_data @students.csv_for_course(current_course) }
    end
  end

  def leaderboard
    @title = "#{current_course.user_term} Roster"
    @sorted_students = params[:team_id].present? ? current_course_data.students_for_team(Team.find(params[:team_id])) : current_course.students
  end

  def show
    self.current_student = current_course.students.where(id: params[:id]).first
    @assignments_with_due_dates = current_course_data.assignments.select { |assignment| assignment.due_at.present? }
    @sorted_teams = current_course.teams.order_by_high_score
    @grade_scheme_elements = current_course.grade_scheme_elements
    @grade_levels_elements_json = @grade_scheme_elements.order(:low_range).pluck(:low_range, :letter, :level).to_json
    @scores_for_current_course = current_student.scores_for_course(current_course)
    if current_course.team_challenges?
      @events = current_course_data.assignments.timelineable.to_a + current_course.challenges
    else
      @events = current_course_data.assignments.timelineable.to_a
    end

    scores = []
    current_course.assignment_types.each do |assignment_type|
      scores << { data: [current_student.grades.released.where(assignment_type: assignment_type).score], name: assignment_type.name }
    end

  end

  def predictions
    current_student.predictions(current_course)
  end

  def choices
    @title = "View all #{current_course.weight_term} Choices"
    @assignment_types = current_course.assignment_types
    @team = current_course.teams.find_by(id: params[:team_id]) if params[:team_id]
  end

  def grading_philosophy
    @grade_scheme_elements = current_course.grade_scheme_elements
    @scores_for_current_course = current_student.scores_for_course(current_course)
  end


  def class_badges
  end

  def badges
    @scores_for_current_course = current_student.scores_for_course(current_course)
  end

  def predictor
    @scores_for_current_course = current_student.scores_for_course(current_course)
  end

  def teams
    @scores_for_current_course = current_student.scores_for_course(current_course)
  end


  def scores_by_assignment
    scores = current_course.grades.released.joins(:assignment_type)
                           .group('grades.student_id, assignment_types.name')
                           .order('grades.student_id, assignment_types.name')
    scores = scores.pluck('grades.student_id, assignment_types.name, SUM(grades.score)')
    render :json => {
      :scores => scores,
    }
  end

  def scores_by_team
    records = current_course.grades.released
                            .joins(:team)
                            .joins('join course_memberships on grades.student_id = course_memberships.user_id')
                            .where('course_memberships.auditing = false')
                            .group('grades.student_id, grades.team_id, teams.name')
                            .order('grades.team_id')
    scores = records.pluck('grades.team_id, SUM(grades.score), teams.name')
    render :json => {
      :scores => scores
    }
  end

  def scores_for_single_assignment
    scores = current_course.grades.released
                                  .joins('join course_memberships on grades.student_id = course_memberships.user_id')
                                  .where('grades.assignment_id = ' + params[:id], 'course_memberships.auditing = false')
    scores = scores.pluck('grades.score')
    render :json => {
      :scores => scores
    }
  end

  #All Admins to see all of one student's grades at once, proof for duplicates
  def grade_index
    self.current_student = current_course.students.where(id: params[:id]).first
    @grades = current_student.grades.where(:course_id => current_course)
  end

  def roster
    @students = current_course.students.being_graded
    respond_to do |format|
      format.html
      format.json { render json: @students }
      format.csv { send_data @students.csv_roster_for_course(current_course) }
    end
  end
end
