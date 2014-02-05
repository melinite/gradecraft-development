class TeamsController < ApplicationController
  respond_to :html, :json

  before_filter :ensure_staff?

  def index
    @teams = current_course.teams.includes(:earned_badges)
    @title = "#{term_for :teams}"
  end

  def show
    @team = current_course.teams.find(params[:id])
    @challenges = current_course.challenges.chronological.alphabetical
    @students = @team.students
  end

  def new
    @team =  current_course.teams.new
    @team_memberships = @team.team_memberships.new
    @title = "Create a New #{term_for :team}"
    @course = current_course
    @users = current_course.users
    @team.team_memberships.build
    @students = @users.students
    @submit_message = "Create #{term_for :team}"
    respond_with @team
  end

  def leaderboard
    @teams = current_course.teams
  end

  def create
    @team =  current_course.teams.new(params[:team])
    @team.save
    @team.team_memberships.build
    respond_with @team
  end

  def edit
    @team =  current_course.teams.find(params[:id])
    @title = "Editing #{@team.name}"
    @users = current_course.users
    @students = @users.students
    @submit_message = "Update #{term_for :team}"
  end

  def update
    @team = current_course.teams.find(params[:id])
    @team.update_attributes(params[:team])
    respond_with @team
  end

  def destroy
    @team = current_course.teams.find(params[:id])
    @team.destroy
    respond_with @team
  end

  private

  def interpolation_options
    { :resource_name => current_course.team_term }
  end

  def sort_column
     current_course.team.column_names.include?(params[:sort]) ? params[:sort] : "id"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end
end
