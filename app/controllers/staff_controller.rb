class StaffController < ApplicationController
  respond_to :html, :json

  before_filter :ensure_admin?

  def index
    @title = "Staff Index"
    @staff = current_course.users
  end

  def show
    @user = current_course.users.find(params[:id])
  end

end
