class AnalyticsController < ApplicationController
  before_filter :ensure_staff?

  def events
    @students = current_course.users.students
    @sorted_students = @students.order('course_memberships.sortable_score DESC')
  end
end
