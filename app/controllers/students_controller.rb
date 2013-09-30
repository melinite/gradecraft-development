class StudentsController < ApplicationController
  respond_to :html, :json

  def index
    @title = "#{current_course.user_term} Roster"
    @teams = current_course.teams
    @assignments = current_course.assignments
    @students = params[:team_id].present? ? current_course_data.students_for_team(Team.find(params[:team_id])) : current_course.students
    respond_to do |format|
      format.html
      format.json { render json: @students }
      format.csv { send_data @students.csv_for_course(current_course) }
      format.xls { send_data @users.csv_for_course(current_course, col_sep: "\t") }
    end
  end

  def leaderboard
    @title = "#{current_course.user_term} Roster"
    @users = current_course.users
    @teams = current_course.teams
    @sorted_students = params[:team_id].present? ? current_course_data.students_for_team(Team.find(params[:team_id])) : current_course.students
    respond_to do |format|
      format.html
      format.json { render json: @users }
      format.csv { send_data User.csv_for_course(current_course) }
      format.xls { send_data @users.csv_for_course(current_course, col_sep: "\t") }
    end
  end

  def show
    self.current_student = current_course.students.where(id: params[:id]).first

    @assignment_types = current_course.assignment_types.includes(:assignments)
    @assignment_weights = current_student.assignment_weights
    @assignment_weight = current_student.assignment_weights.new
    @assignments = current_course.assignments.includes(:submissions, :assignment_type)
    @assignments_with_due_dates = @assignments.select { |assignment| assignment.due_at.present? }
    @grades = current_student.grades
    @badges = current_course_data.badges.includes(:earned_badges, :tasks)
    @earned_badges = current_student.earned_badges
    @teams = current_course.teams
    @grade_scheme = current_course.grade_scheme
    @predictions = current_student.predictions(current_course)
    @scores_for_current_course = current_student.scores_for_course(current_course)
    if current_course.team_challenges?
      @events = current_course.assignments + current_course.challenges
    else
      @events = current_course.assignments
    end

    @form = AssignmentTypeWeightForm.new(current_student, current_course)

    scores = []
    current_course.assignment_types.each do |assignment_type|
      scores << { data: [current_student.grades.released.where(assignment_type: assignment_type).score], name: assignment_type.name }
    end

  end
end
