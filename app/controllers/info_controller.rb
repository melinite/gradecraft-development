class InfoController < ApplicationController
  helper_method :sort_column, :sort_direction, :predictions

  before_filter :require_login, :except => [:people, :research, :submit_a_bug, :news, :features, :using_gradecraft]

  def dashboard
    @cache_keys = Course.connection.select_all(<<-SQL).first
      SELECT md5(extract(epoch from updated_at)::varchar) AS course_key,
             md5(concat(
                (SELECT sum(extract(epoch from updated_at)) FROM assignments WHERE assignments.course_id = courses.id),
                (SELECT sum(extract(epoch from updated_at)) FROM assignment_types WHERE assignment_types.course_id = courses.id),
                (SELECT sum(extract(epoch from score_levels.updated_at)) FROM assignment_types JOIN score_levels on score_levels.assignment_type_id = assignment_types.id WHERE assignment_types.course_id = courses.id)
             )) AS assignments_key,
             md5(concat(
                (SELECT sum(extract(epoch from updated_at)) FROM grades WHERE grades.course_id = courses.id)
             )) AS grades_key,
             md5(concat(
                (SELECT sum(extract(epoch from updated_at)) FROM badges WHERE badges.course_id = courses.id),
                (SELECT sum(extract(epoch from updated_at)) FROM earned_badges WHERE earned_badges.course_id = courses.id)
             )) AS badges_key,
             md5(concat(
                (SELECT sum(extract(epoch from updated_at)) FROM earned_badges WHERE course_id = courses.id and student_id = #{current_student.id})
             )) AS student_badges_key
       FROM courses
      WHERE courses.id = #{current_course.id}
    SQL
    @assignments = current_course.assignments.includes(:course, assignment_type: [:score_levels]).alphabetical.chronological
    if current_user.is_staff?
      @students = current_course.users.students
      @teams = current_course.teams.includes(:earned_badges)
      @users = current_course.users
      @top_ten_students = @students.order_by_high_score.limit(10)
      @bottom_ten_students = @students.order_by_low_score.limit(10)
      @submissions = current_course.submissions
    else
      @by_assignment_type = @assignments.alphabetical.chronological.group_by(&:assignment_type)
      @sorted_teams = current_course.teams.order_by_high_score
      @grade_scheme = current_course.grade_scheme
      @scores_for_current_course = current_student.scores_for_course(current_course)
    end
    if current_course.team_challenges?
      @events = @assignments.to_a + current_course.challenges
    else
      @events = @assignments.to_a
    end
  end

  def predictions
    current_student.predictions(current_course)
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
