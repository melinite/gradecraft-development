class UserSessionsController < ApplicationController

  skip_before_filter :require_login, :except => [:index]
  skip_before_filter :verify_authenticity_token, :only => [:lti_create, :kerberos_create]

  def new
    @user = User.new
  end

  def create
    respond_to do |format|
      if @user = login(params[:user][:email], params[:user][:password], params[:user][:remember_me])
        log_course_login_event
        format.html { redirect_back_or_to dashboard_path }
        format.xml { render :xml => @user, :status => :created, :location => @user }
      else
        @user = User.new
        format.html { flash.now[:error] = "Email or Password were invalid, login failed."; render :action => "new" }
        format.xml { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  def lti_create
    @user = User.find_or_create_by_lti_auth_hash(auth_hash)
    @course = Course.find_by_lti_uid(auth_hash['extra']['raw_info']['context_id'])
    if !@user || !@course
      lti_error_notification
      flash[:alert] = t('sessions.create.error')
      redirect_to auth_failure_path
      return
    end
    @user.courses << @course unless @user.courses.include?(@course)
    save_lti_context
    auto_login @user
    respond_with @user, notice: t('sessions.create.success'), location: dashboard_path
  end

  def kerberos_create
    @user = User.find_by_kerberos_auth_hash(auth_hash)
    if !@user
      kerberos_error_notification
      flash[:alert] = t('sessions.create.error')
      redirect_to auth_failure_path and return
    end
    auto_login @user
    respond_with @user, notice: t('sessions.create.success'), location: dashboard_path
  end

  def destroy
    logout
    redirect_to root_url, :notice => "You are now logged out. Thanks for playing!"
  end

  private

  def auth_hash
    request.env['omniauth.auth']
  end

  def lti_error_notification
    info = auth_hash['info']
    user = { name: "#{info['first_name']} #{info['last_name']}", email: info['email'], uid: auth_hash['uid'] }
    course = { name: auth_hash['extra']['context_label'], uid: auth_hash['extra']['context_id'] }
    NotificationMailer.lti_error(user, course).deliver
  end

  def kerberos_error_notification
    user = { uid: auth_hash['uid'] }
    NotificationMailer.kerberos_error(user).deliver
  end

  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    clear_return_to
  end

end
