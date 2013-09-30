class NotificationMailer < ActionMailer::Base
  default from: 'mailer@gradecraft.com'

  def lti_error(user_info, course_info)
    @user = user_info
    @course = course_info
    mail(:to => 'cholma@umich.edu', :subject => 'Unknown LTI user/course') do |format|
      format.text
      format.html
    end
  end

  def kerberos_error(user_info)
    @user = user_info
    mail(:to => 'cholma@umich.edu', :subject => 'Unknown Kerberos user') do |format|
      format.text
      format.html
    end
  end

  def successful_submission(user_info, submission_info)
    @user = user_info
    @submission = submission_info
    mail(:to => "#{@user[:email]}", :subject => "#{@submission[:name]} Submitted") do |format|
      format.text
      format.html
    end
  end

  def grade_released(grade_id)
    @grade = Grade.find grade_id
    @user = @grade.student
    @assignment = @grade.assignment
    mail(:to => @user.email, :subject => "#{@assignment.name} Graded") do |format|
      format.text
      format.html
    end
  end

end
