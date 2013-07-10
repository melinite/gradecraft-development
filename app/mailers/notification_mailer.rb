class NotificationMailer < ActionMailer::Base
  default from: 'cholma@umich.edu'

  def lti_error(user_info, course_info)
    @user = user_info
    @course = course_info
    mail(:to => 'cholma@umich.edu', :subject => 'Unknown LTI user/course')
  end
end
