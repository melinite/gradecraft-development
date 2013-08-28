class EventLogger
  include Sidekiq::Worker

  def log(event, data, user=nil, assignment=nil)
    AnalyticsEvent.create(type: event, data: data, created_at: Time.now, user_id: user, assignment_id: assignment)
  end
end
