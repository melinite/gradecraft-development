class UsersController < ApplicationController
  respond_to :html, :json

  before_filter :ensure_staff?, :only => [:index, :destroy, :show, :edit, :new, :create, :update, :upload, :import]
  before_filter :ensure_admin?, :only => [:all]

  def index
    @title = "View All Users"
    @users =  current_course.users
    @team = current_course.teams.find_by(id: params[:team_id]) if params[:team_id]
    user_search_options = {}
    user_search_options['team_memberships.team_id'] = params[:team_id] if params[:team_id].present?
    @users = current_course.users.includes(:teams, :earned_badges).where(user_search_options).alpha
    respond_to do |format|
      format.html
      format.json { render json: @users }
      format.csv { send_data @users.to_csv }
      format.xls { send_data @users.to_csv(col_sep: "\t") }
    end
  end

  def all
    @title = "View all Users"
    @users = User.all.order('last_name ASC')
    user_search_options = {}
    user_search_options['team_memberships.team_id'] = params[:team_id] if params[:team_id].present?
    @users = current_course.users.includes(:teams, :earned_badges).where(user_search_options)
    respond_to do |format|
      format.html
      format.json { render json: @users }
      format.csv { send_data @users.to_csv }
      format.xls { send_data @users.to_csv(col_sep: "\t") }
    end
  end

  def new
    @title = "Create a New User"
    @teams = current_course.teams.alpha
    @courses = Course.all
    @user = current_course.users.new
    respond_with @user
  end

  def edit
    session[:return_to] = request.referer
    @teams = current_course.teams

    if current_user.is_admin?
      @courses = Course.all
    end
    @user = current_course.users.find(params[:id])
    @course_membership = @user.course_memberships.where(course_id: current_course).first
    @title = "Edit #{@user.name}"
    @academic_history = @user.student_academic_history
  end

  def create
    @teams = current_course.teams
    @user = current_course.users.new(params[:user])
    if @user.save && @user.is_student?
      redirect_to students_path, :notice => "#{term_for :student} was successfully created!"
    elsif @user.save && @user.is_staff?
      redirect_to staff_index_path, :notice => "Staff Member was successfully created!"
    else
      render :new
    end
    expire_action :action => :index
  end

  def update
    @user = User.find(params[:id])
    @course_membership = @user.course_memberships.where(course_id: current_course).first
    @teams = current_course.teams
    #@course_membership.update_attributes(params[:course_membership])
    @user.update_attributes(params[:user])
    if @user.save && @user.is_student?
      redirect_to session.delete(:return_to), :notice => "#{@user.name} was successfully updated!"
    elsif @user.save && @user.is_staff?
      redirect_to session.delete(:return_to), :notice => "#{@user.name} was successfully updated!"
    else
      render :edit
    end
  end

  def destroy
    @user = current_course.users.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :ok }
    end

  end

  def edit_profile
    @title = "Edit My Account"
    @user = current_user
  end

  def update_profile
    @user = current_user
    @user.update_attributes(params[:user])
    redirect_to dashboard_path
  end

  def import
    @title = "Import Users"
  end

  #import users for class
  def upload
    require 'csv'

    if params[:file].blank?
      flash[:notice] = "File missing"
      redirect_to users_path
    else
      CSV.foreach(params[:file].tempfile, :headers => false) do |row|
        User.create! do |u|
          u.first_name = row[0]
          u.last_name = row[1]
          u.username = row[2]
          u.email = row[3]
          u.role = 'student'
        end
      end
      redirect_to users_path, :notice => "Upload successful"
    end
  end

  def final_grades
    @course = current_course
  end

  def search
    q = params[:user][:name]
    @users = current_course.users.where("name LIKE ?","%#{q}%")
  end

  private

  def increment_predictor_views
    User.increment_counter(:predictor_views, current_user.id) if current_user && request.format.html?
  end
end
