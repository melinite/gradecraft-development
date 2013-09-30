class InfoController < ApplicationController
  helper_method :sort_column, :sort_direction

  before_filter :require_login, :except => [:people, :research, :submit_a_bug, :news, :features, :using_gradecraft]

  def dashboard
    @students = current_course.users.students
    if current_user.is_staff?
      @teams = current_course.teams.includes(:earned_badges)
      @users = current_course.users
      @top_ten_students = @students.order_by_high_score.limit(10)
      @bottom_ten_students = @students.order_by_low_score.limit(10)
      @submissions = current_course.submissions
    else
      @submissions = current_student.submissions
      @badges = current_course.badges.includes(:tasks)
      @earned_badges = current_student.earned_badges.includes(:badge)
      @assignments = current_course.assignments.includes(:course, assignment_type: [:score_levels]).alphabetical.chronological
      @teams = current_course.teams
      @sorted_teams = @teams.order_by_high_score
      @grade_scheme = current_course.grade_scheme
      @predictions = current_student.predictions(current_course)
      @scores_for_current_course = current_student.scores_for_course(current_course)
      if current_course.team_challenges?
        @events = current_course.assignments + current_course.challenges
      else
        @events = current_course.assignments
      end
    end
  end

  def grading_status
    @team = current_course.teams.find_by(id: params[:team_id]) if params[:team_id]
    @students = current_course.users.students
    @top_ten_students = @students.order_by_high_score.limit(10)
    @bottom_ten_students = @students.order_by_low_score.limit(10)
    @ungraded_submissions = current_course.submissions.ungraded
    @badges = current_course.badges.includes(:tasks)
    @user = current_user
    @assignments = current_course.assignments.includes(:assignment_type)
    @assignment_types = current_course.assignment_types.includes(:assignments)
  end

  def leaderboard
    @teams = current_course.teams.includes(:earned_badges)
    @students = current_course.users.students
    @top_ten_students = @students.order_by_high_score.limit(10)
    @bottom_ten_students = @students.order_by_low_score.limit(10)
    @submissions = current_course.submissions
    @badges = current_course.badges.includes(:tasks)
    @user = current_user
    @assignments = current_course.assignments.includes(:assignment_type)
    @assignment_types = current_course.assignment_types.includes(:assignments)
  end
end
