class UsersController < ApplicationController
  respond_to :html, :json

  skip_before_filter :require_login, :only => [:create, :new]
  before_filter :ensure_staff?, :only => [:index, :destroy, :show, :edit, :new]
  before_filter :ensure_admin?, :only => :all_users

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
    @users =  current_course.users.order('last_name ASC')
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

  def all
    @title = "View all Users"
    @users = User.all
    respond_to do |format|
      format.html
      format.json { render json: @all_users }
    end
  end

  def staff
    @title = "Staff"
    @users = current_course.users
  end

  def class_badges
    @students = current_course.students.includes(:earned_badges)
    @user = current_user
    @assignments = @user.assignments
    @badges = current_course.badges
    user_search_options = {}
    user_search_options['team_memberships.team_id'] = params[:team_id] if params[:team_id].present?
    respond_to do |format|
      format.html
      format.json { render json: @users }
      format.csv { send_data User.csv_for_course(current_course) }
      format.xls { send_data @users.csv_for_course(current_course, col_sep: "\t") }
    end
  end

  def analytics
    @users = current_course.users
    @students = current_course.students
    @teams = current_course.teams
    user_search_options = {}
    user_search_options['team_memberships.team_id'] = params[:team_id] if params[:team_id].present?
    @sorted_students = @students.includes(:teams).where(user_search_options).order_by_high_score
    respond_to do |format|
      format.html
      format.json { render json: @users }
      format.csv { send_data @users.to_csv }
      format.xls { send_data @users.to_csv(col_sep: "\t") }
    end
  end

  def predictor
    increment_predictor_views

    if current_user.is_staff?
      student = User.find(params[:user_id])
    else
      student = current_user
    end

    scores = []
    current_course.assignment_types.pluck(:id, :name).each do |assignment_type_id, assignment_type_name|
      scores << { data: [student.grades.released.where(assignment_type_id: assignment_type_id).score], name: assignment_type_name }
    end

    earned_badge_score = student.earned_badges.where(course: current_course).score
    scores << { :data => [earned_badge_score], :name => 'Badges' }

    assignments = current_course.assignments
    assignments = assignments.graded_for_student(student) if params[:in_progress]

    render :json => {
      :student_name => student.name,
      :scores => scores,
      :course_total => assignments.point_total + earned_badge_score
    }
  end

  def scores_by_assignment
    scores = current_course.grades.released.joins(:assignment_type)
                           .group('grades.student_id, assignment_types.name')
                           .order('grades.student_id, assignment_types.name')
    scores = scores.pluck('grades.student_id, assignment_types.name, SUM(grades.score)')
    render :json => {
      :scores => scores,
    }
  end

  def scores_for_current_course
     scores = current_course.grades.released.group(:student_id).order('SUM(score)')
     id = params[:user_id] || current_user.id
     user_score = current_course.grades.released.group(:student_id)
                                                .where(student_id: id).pluck('SUM(score)')
     scores = scores.pluck('SUM(score)')
     render :json => {
      :scores => scores,
      :user_score => user_score
     }
  end

  def new
    @title = "Create a New User"
    @teams = current_course.teams.alpha
    @courses = Course.all
    @user = current_course.users.new
    respond_with @user
  end

  def edit
    @title = "Edit #{current_course.user_term}"
    @teams = current_course.teams
    @courses = Course.all
    @user = current_course.users.find(params[:id])
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
      redirect_to students_path, :notice => "#{term_for :student} was successfully created!"
    elsif @user.save && @user.is_staff?
      redirect_to staff_index_path, :notice => "Staff Member was successfully created!"
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

  def choices
    @title = "View all #{current_course.weight_term} Choices"
    @students = current_course.students
    @assignment_types = current_course.assignment_types
    @teams = current_course.teams
    user_search_options = {}
    user_search_options['team_memberships.team_id'] = params[:team_id] if params[:team_id].present?
    @students = @students.includes(:teams).where(user_search_options).order_by_high_score
  end

  def final_grades
    @course = current_course
  end

  def search
    q = params[:user][:name]
    @users = User.find(:all, :conditions => ["name LIKE %?%",q])
  end

  private

  def increment_predictor_views
    User.increment_counter(:predictor_views, current_user.id) if current_user && request.format.html?
  end
end
