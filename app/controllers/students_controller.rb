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
    @students = current_course.students.being_graded
    respond_to do |format|
      format.html
      format.csv { send_data @students.csv_for_course(current_course) }
    end
  end

  # Course timeline, displays all assignments that are determined by the instructor to belong on the timeline + team challenges if present
  def timeline
    if current_course.team_challenges?
      @events = current_course.assignments.timelineable.to_a + current_course.challenges
    else
      @events = current_course.timelineable.to_a
    end
  end

  # Exporting student grades 
  def export
    @students = current_course.students.being_graded respond_to do |format|
      format.html
      format.json { render json: @students.where("first_name like ?", "%#{params[:q]}%") }
      format.csv { send_data @students.csv_for_course(current_course) }
    end
  end

  # Displaying ranked order of students and scores
  def leaderboard
    @title = "#{current_course.user_term} Leaderboard"
    @sorted_students = params[:team_id].present? ? current_course_data.students_for_team(Team.find(params[:team_id])) : current_course.students
  end

  def show
    self.current_student = current_course.students.where(id: params[:id]).first
    
    scores = []
    current_course.assignment_types.each do |assignment_type|
      scores << { data: [current_student.grades.released.where(assignment_type: assignment_type).score], name: assignment_type.name }
    end

  end

  # Student predictions - can be taken out? 
  def predictions
    current_student.predictions(current_course)
  end

  # Displaying the course grading scheme and professor's grading philosophy
  def grading_philosophy
    @grade_scheme_elements = current_course.grade_scheme_elements
  end

  # Display the grade predictor
  def predictor
    @grade_scheme_elements = current_course.grade_scheme_elements
    @grade_levels_json = @grade_scheme_elements.order(:low_range).pluck(:low_range, :letter, :level).to_json
  end

  #TODO: Should be moved to a method
  def scores_by_assignment
    scores = current_course.grades.released.joins(:assignment_type)
                           .group('grades.student_id, assignment_types.name')
                           .order('grades.student_id, assignment_types.name')
    scores = scores.pluck('grades.student_id, assignment_types.name, SUM(grades.score)')
    render :json => {
      :scores => scores,
    }
  end

  #All Admins to see all of one student's grades at once, proof for duplicates
  def grade_index
    self.current_student = current_course.students.where(id: params[:id]).first
    @grades = current_student.grades.where(:course_id => current_course)
  end
end
