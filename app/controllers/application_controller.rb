require 'application_responder'

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  #Canable details
  include Canable::Enforcers
  include Omniauth::Lti::Context
  include CustomNamedRoutes
  include CurrentScopes
  include CourseTerms
  delegate :can_view?, :to => :current_user
  helper_method :can_view?
  hide_action :can_view?

  respond_to :html

  protect_from_forgery

  Rails.env.production? do
    before_filter :check_url
  end

  def check_url
    redirect_to request.protocol + "www." + request.host_with_port + request.fullpath if !/^www/.match(request.host)
  end

  before_filter :require_login, :except => [:not_authenticated]

  before_filter :increment_page_views

  include ApplicationHelper

  def not_authenticated
    if request.env["REMOTE_USER"] != nil
      @user = User.find_by_username(request.env["REMOTE_USER"])
      if @user
        auto_login(@user)
        User.increment_counter(:visit_count, current_user.id) if current_user
        redirect_to dashboard_path
      else
        redirect_to root_url, :alert => "Please login first."
        #We ultimately need to handle Cosign approved users who don't have GradeCraft accounts
      end
    else
      redirect_to root_path, :alert => "Please login first."
    end
  end

  protected


  def ensure_staff?
    return not_authenticated unless current_user.is_staff?
  end

  private
  def increment_page_views
    if current_user && request.format.html?
      User.increment_counter(:page_views, current_user.id)
      EventLogger.perform_async('pageview', course_id: current_course.id, user_id: current_user.id, page: request.original_fullpath)
    end
  end

  def enforce_view_permission(resource)
    raise Canable::Transgression unless can_view?(resource)
  end

  def log_course_login_event
    membership = current_user.course_memberships.where(course_id: current_course.id).first
    EventLogger.perform_async('login', course_id: current_course.id, user_id: current_user.id, last_login_at: membership.last_login_at.to_i)
    membership.update_attribute(:last_login_at, Time.now)
  end

end
