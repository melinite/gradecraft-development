class InfoController < ApplicationController
  helper_method :sort_column, :sort_direction

  before_filter :require_login, :except => [:people, :research, :submit_a_bug, :news, :features, :using_gradecraft]

  def dashboard
    if current_user.is_staff?
      @teams = current_course.teams.includes(:earned_badges)
      @users = current_course.users
      @students = current_course.users.students
      @top_ten_students = @students.order_by_high_score.limit(10)
      @bottom_ten_students = @students.order_by_low_score.limit(10)
      @submissions = current_course.submissions
    end
    @badges = current_course.badges.includes(:tasks)
    @user = current_user
    @students = current_course.users.students
    @assignments = current_course.assignments.includes(:assignment_type)
    @assignment_types = current_course.assignment_types.includes(:assignments)
    @teams = current_course.teams
    @sorted_teams = @teams.order_by_high_score
  end

  def grading_status
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
