class HomeController < ApplicationController

 before_filter :require_login, :only => [:login, :register]

  def index
    if current_user
      redirect_to dashboard_path
    end
  end

end
