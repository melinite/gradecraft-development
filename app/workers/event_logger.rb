class EventLogger
  include Sidekiq::Worker

  def perform(event_type, course_id, user_id, data={})
    Analytics::Event.create(
      event_type: event_type,
      course_id: course_id,
      user_id: user_id,
      data: data,
      created_at: Time.now
    )
  end
end
