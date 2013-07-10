class UserSessionsController < ApplicationController

  skip_before_filter :require_login, :except => [:destroy, :new, :index]
  skip_before_filter :verify_authenticity_token, :only => [:lti_create]

  def new
    @user = User.new
  end

  def create
    respond_to do |format|
      if @user = login(params[:user][:email],params[:user][:password],params[:user][:remember_me])
        #User.increment_counter(:visit_count, current_user.id) if current_user
        format.html { redirect_back_or_to dashboard_path }
        format.xml { render :xml => @users, :status => :created, :location => @user }
      else
        @user = User.new
        format.html { flash.now[:alert] = "Login failed."; render :action => "new" }
        format.xml { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  def lti_create
    @user = User.find_or_create_by_lti_auth_hash(auth_hash)
    if @user
      save_lti_context
      auto_login @user
      flash[:notice] = t('sessions.lti.success')
    else
      flash[:alert] = t('sessions.lti.error')
    end
    respond_with @user do |format|
      format.html { redirect_to dashboard_path }
    end
  end

  def destroy
    logout
    redirect_to 'root', :notice => "Logged out!"
  end

  private

  def auth_hash
    request.env['omniauth.auth']
  end
end
