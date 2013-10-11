class UsersController < ApplicationController
  respond_to :html, :json

  skip_before_filter :require_login, :only => [:create, :new]
  before_filter :ensure_staff?, :only => [:index, :destroy, :show, :edit, :new]
  before_filter :ensure_admin?, :only => [:all]

  def import
    if request.post? && params[:file].present?
      infile = params[:file].read
      n, errs = 0, []

      CSV.parse(infile) do |row|
        n += 1

        next if n == 1 or row.join.blank?

        user = User.build_from_csv(row)

        if user.valid?
          user.save
        else
          errs << row
        end
      end

      if errs.any?
        errFile ="errors_#{Date.today.strftime('%d%b%y')}.csv"
        errs.insert(0, User.csv_header)
        errCSV = CSV.generate do |csv|
          errs.each {|row| csv << row}
        end
        send_data errCSV,
          :type => 'text/csv; charset=iso-8859-1; header=present',
          :disposition => "attachment; filename=#{errFile}.csv"
      else
        flash[:notice] = I18n.t('user.import.success')
        redirect_to import_url
      end
    end
  end

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

  def staff
    @title = "Staff"
    @users = current_course.users
  end


  def new
    @title = "Create a New User"
    @teams = current_course.teams.alpha
    @courses = Course.all
    @user = current_course.users.new
    respond_with @user
  end

  def edit
    @teams = current_course.teams
    @courses = Course.all
    @user = current_course.users.find(params[:id])
    @title = "Edit #{@user.name}"
    @academic_history = @user.student_academic_history

    respond_with @user
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
    @teams = Team.all
    @user.update_attributes(params[:user])
    if @user.save && @user.is_student?
      redirect_to students_path, :notice => "#{term_for :student} was successfully updated!"
    elsif @user.save && @user.is_staff?
      redirect_to staff_index_path, :notice => "Staff Member was successfully updated!"
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
    @badges = current_course.badges
    @user = current_user
    @assignments = @user.assignments
    if current_user.is_student?
      @scores_for_current_course = current_student.scores_for_course(current_course)
      @by_assignment_type = @assignments.alphabetical.chronological.group_by(&:assignment_type)
      @sorted_teams = current_course.teams.order_by_high_score
    end
  end

  def update_profile
    @user = current_user
    @user.update_attributes(params[:user])
    redirect_to dashboard_path
  end

  def import
    @title = "Import Users"
  end

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
