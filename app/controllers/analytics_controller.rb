class AnalyticsController < ApplicationController
  before_filter :ensure_staff?

  def index
    @students = current_course.users.students.order('last_name ASC')
  end

  def all_events
    data = CourseEvent.data(:minutely, 15.minutes.ago, Time.now, {course_id: current_course.id}, {event_type: "_all"})

    render json: data
  end

  def assignment_events
    assignments = Hash[current_course.assignments.select([:id, :name]).collect{ |h| [h.id, h.name] }]
    data = AssignmentEvent.data(:minutely, 15.minutes.ago, Time.now, {assignment_id: assignments.keys}, {event_type: "_all"})

    data.decorate! { |result| result[:name] = assignments[result.assignment_id] }

    render json: data
  end

  def login_frequencies
    granularity = :minutely
    data = CourseLogin.data(granularity, 15.minutes.ago, Time.now, {course_id: current_course.id})

    data[:lookup_keys] = ['{{t}}.average']
    data.decorate! do |result|
      # Get frequency
      result[granularity].each do |key, values|
        result[granularity][key][:average] = (values['total'] / values['count']).round(2)
      end
    end

    render json: data
  end

  def login_events
    granularity = :minutely
    data = CourseLogin.data(granularity, 15.minutes.ago, Time.now, {course_id: current_course.id})

    # Only graph counts
    data[:lookup_keys] = ['{{t}}.count']

    render json: data
  end

  def all_pageview_events
    data = CoursePageview.data(:minutely, 15.minutes.ago, Time.now, {course_id: current_course.id}, {page: "_all"})

    render json: data
  end

  def pageview_events
    data = CoursePagePageview.data(:minutely, 15.minutes.ago, Time.now, {course_id: current_course.id})
    data.decorate! { |result| result[:name] = result.page }

    render json: data
  end

  def prediction_averages
    granularity = :minutely
    data = CoursePrediction.data(granularity, 15.minutes.ago, Time.now, {course_id: current_course.id})

    data[:lookup_keys] = ['{{t}}.average']
    data.decorate! do |result|
      result[granularity].each do |key, values|
        result[granularity][key][:average] = (values['total'] / values['count'] * 100).to_i
      end
    end

    render json: data
  end

  def assignment_prediction_averages
    assignments = Hash[current_course.assignments.select([:id, :name]).collect{ |h| [h.id, h.name] }]
    granularity = :minutely
    data = AssignmentPrediction.data(granularity, 15.minutes.ago, Time.now, {assignment_id: assignments.keys})

    data[:lookup_keys] = ['{{t}}.average']
    data.decorate! do |result|
      result[:name] = assignments[result.assignment_id]
      result[granularity].each do |key, values|
        result[granularity][key][:average] = (values['total'] / values['count'] * 100).to_i
      end
    end

    render json: data
  end
end