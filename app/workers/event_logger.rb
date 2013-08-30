class EventLogger
  include Sidekiq::Worker

  def perform(event, data={}, user=nil, assignment=nil)
    AnalyticsEvent.create(event_type: event, data: data, created_at: Time.now, user_id: user, assignment_id: assignment)
  end
end
