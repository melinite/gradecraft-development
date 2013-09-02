class EventLogger
  include Sidekiq::Worker

  def perform(event_type, course_id, user_id=nil, assignment_id=nil, data={})
    Analytics::Event.create(
      event_type: event_type,
      course_id: course_id,
      user_id: user_id,
      assignment_id: assignment_id,
      data: data,
      created_at: Time.now
    )
  end
end
