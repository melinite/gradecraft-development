class AnalyticsController < ApplicationController
  before_filter :ensure_staff?

  def index
    @students = current_course.users.students.order('last_name ASC')
  end

  def assignment_events
    assignments = Hash[current_course.assignments.select([:id, :name]).collect{ |h| [h.id, h.name] }]

    render json: Analytics::AssignmentEvent.data(:minutely, 15.minutes.ago, Time.now, assignments)
  end

  def login_frequencies
    render json: Analytics::CourseLogin.data(:minutely, 15.minutes.ago, Time.now, current_course, :frequency)
  end

  def login_events
    render json: Analytics::CourseLogin.data(:minutely, 15.minutes.ago, Time.now, current_course, :count)
  end

  def pageview_events
    render json: Analytics::CoursePageview.data(:minutely, 15.minutes.ago, Time.now, current_course)
  end

  def prediction_averages
    render json: Analytics::CoursePrediction.data(:minutely, 15.minutes.ago, Time.now, current_course)
  end
end
