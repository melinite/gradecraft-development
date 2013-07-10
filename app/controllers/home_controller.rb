class HomeController < ApplicationController
    
 before_filter :require_login, :only => [:login, :register]
  
  def index 
    if current_user
      if current_user.is_admin?
      else
        @user = current_user
        @student_assignment_type_weights = @user.student_assignment_type_weights.all
        @student_assignment_type_weight = @user.student_assignment_type_weights.new
        @assignment_types = current_course.assignment_types.includes(:assignments)
      end
      @teams = current_course.try(:teams)
      @users = current_course.try(:users)
      @badges = current_course.badges
      @students = current_course.users.students
      @top_ten_students = @students.order('course_memberships.sortable_score DESC').limit(10)
      @bottom_ten_students = @students.order('course_memberships.sortable_score ASC').limit(10)
      @assignments = current_course.try(:assignments)
    end
  end

end
