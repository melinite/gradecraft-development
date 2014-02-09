class CurrentCoursesController < ApplicationController

  respond_to :json 

  # Switch between enrolled courses 
  def change
    if course = current_user.courses.where(:id => params[:course_id]).first
      unless session[:course_id] == course.id
        session[:course_id] = course.id
        log_course_login_event
      end
    end
    redirect_to root_url
  end

  def show
    respond_with current_course.as_json(only: [:id], methods: [:total_points])
  end
  
end
