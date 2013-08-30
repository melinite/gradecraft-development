class AnalyticsController < ApplicationController
  before_filter :ensure_staff?

  def index
    @students = current_course.users.students.order('last_name ASC')
  end

  def assignment_events
    assignments = Hash[current_course.assignments.select([:id, :name]).collect{ |h| [h.id, h.name] }]
    interval = 1.minute.to_i
    start_at = AnalyticsAggregate.time_key(15.minutes.ago, interval)
    end_at = Time.now.to_i
    range = (start_at..end_at).step(interval)

    keys = range.map { |i| :"events.predictor.minutely.#{i}"}

    data = AnalyticsAggregate::AssignmentAggregate.
      in(assignment_id: assignments.keys).
      where('$or' => keys.map{ |k| {k => { '$exists' => true}} }).
      only("assignment_id", *(keys.map{ |k| "#{k}.count" })).to_a

    puts data.inspect

    events = data.collect { |d| d.events.keys }.flatten.uniq

    render json: {
      range: range,
      events: events,
      assignments: assignments,
      data: data
    }
  end
end
