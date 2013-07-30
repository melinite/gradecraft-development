class InfoController < ApplicationController
  helper_method :sort_column, :sort_direction

  before_filter :require_login, :except => [:people, :research, :submit_a_bug, :news, :features, :using_gradecraft]

  def dashboard
    if current_user.is_staff?
      @teams = current_course.teams.includes(:earned_badges)
      @users = current_course.users
      @students = @users.students
      @top_ten_students = @students.winning.limit(10)
      @bottom_ten_students = @students.losing.limit(10)
    end
    @badges = current_course.badges.includes(:tasks)
    @user = current_user
    @assignments = current_course.assignments.includes(:submissions, :assignment_type)
    @assignment_types = current_course.assignment_types.includes(:assignments)
    @submissions = current_course.submissions.includes(:student)
  end
end
