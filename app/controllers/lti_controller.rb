class LTIController < ApplicationController
  def launch
    @consumer = IMS::LTI::ToolConsumer.new(ENV['PIAZZA_CONSUMER_KEY'], ENV['PIAZZA_CONSUMER_SECRET'], 'launch_url' => 'https://piazza.com/connect')
    @consumer.resource_link_id = 1
    @consumer.resource_link_title = 'Q&A'
    @consumer.lis_person_name_full = current_user.name
    @consumer.lis_person_contact_email_primary = current_user.email
    @consumer.user_id = current_user.id
    if current_user.is_admin? || current_user.is_prof?
      @consumer.roles = 'Instructor'
    else
      @consumer.roles = 'Learner'
    end
    @consumer.context_id = current_course.id
    @consumer.context_title = current_course.name
    @consumer.tool_consumer_instance_name = 'Gradecraft'
    @consumer.tool_consumer_instance_guid = 'gradecraft.com'
  end
end
