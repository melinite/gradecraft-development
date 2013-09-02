class AnalyticsController < ApplicationController
  before_filter :ensure_staff?

  def index
    @students = current_course.users.students.order('last_name ASC')
  end

  def assignment_events
    assignments = Hash[current_course.assignments.select([:id, :name]).collect{ |h| [h.id, h.name] }]

    render json: Analytics::AssignmentEvent.data(:minutely, 15.minutes.ago, Time.now, assignments)
  end
end
