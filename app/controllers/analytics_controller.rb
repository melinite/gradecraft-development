class AnalyticsController < ApplicationController
  before_filter :ensure_staff?, :only => [:index]
  before_filter :set_granularity_and_range

  def index
    @students = current_course.users.students.order('last_name ASC')
  end

  def all_events
    data = CourseEvent.data(@granularity, @range, {course_id: current_course.id}, {event_type: "_all"})

    render json: data
  end

  def assignment_events
    assignments = Hash[current_course.assignments.select([:id, :name]).collect{ |h| [h.id, h.name] }]
    data = AssignmentEvent.data(@granularity, @range, {assignment_id: assignments.keys}, {event_type: "_all"})

    data.decorate! { |result| result[:name] = assignments[result.assignment_id] }

    render json: data
  end

  def login_frequencies
    data = CourseLogin.data(@granularity, @range, {course_id: current_course.id})

    data[:lookup_keys] = ['{{t}}.average']
    data.decorate! do |result|
      # Get frequency
      result[data[:granularity]].each do |key, values|
        result[data[:granularity]][key][:average] = (values['total'] / values['count']).round(2)
      end
    end

    render json: data
  end

  def login_events
    data = CourseLogin.data(@granularity, @range, {course_id: current_course.id})

    # Only graph counts
    data[:lookup_keys] = ['{{t}}.count']

    render json: data
  end

  def all_pageview_events
    data = CoursePageview.data(@granularity, @range, {course_id: current_course.id}, {page: "_all"})

    render json: data
  end

  def pageview_events
    data = CoursePagePageview.data(@granularity, @range, {course_id: current_course.id})
    data.decorate! { |result| result[:name] = result.page }

    render json: data
  end

  def prediction_averages
    data = CoursePrediction.data(@granularity, @range, {course_id: current_course.id})

    data[:lookup_keys] = ['{{t}}.average']
    data.decorate! do |result|
      result[data[:granularity]].each do |key, values|
        result[data[:granularity]][key][:average] = (values['total'] / values['count'] * 100).to_i
      end
    end

    render json: data
  end

  def assignment_prediction_averages
    assignments = Hash[current_course.assignments.select([:id, :name]).collect{ |h| [h.id, h.name] }]
    data = AssignmentPrediction.data(@granularity, @range, {assignment_id: assignments.keys})

    data[:lookup_keys] = ['{{t}}.count','{{t}}.total']
    data.decorate! do |result|
      result[:name] = assignments[result.assignment_id]
    end

    render json: data
  end

  private
  def set_granularity_and_range
    @granularity = params[:granularity].presence && params[:granularity].to_sym
    @range = params[:range].presence && params[:range].to_sym
  end
end
