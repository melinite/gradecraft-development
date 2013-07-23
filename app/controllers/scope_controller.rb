class ScopeController < ApplicationController
  def change
    if current_user.admin?
      Course.find(params[:course])
    else
      current_user.courses.find(course_id)
    end

    session[:course_id] = course.id if course

    redirect_to root_path
  end
end
