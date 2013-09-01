class GroupsController < ApplicationController
  before_filter :ensure_staff?, :only => :index

  def index
    @groups = current_course.groups
  end

  def show
    if current_user.is_student?
      @user = current_user
      @badges = current_course.badges
      @assignments = current_course.assignments
    end
    @group = current_course.groups.find(params[:id])
  end

  def new
    if current_user.is_student?
      @user = current_user
      @badges = current_course.badges
      @assignments = current_course.assignments
    end
    @group = current_course.groups.new
  end

  def create
    @group = current_course.groups.new(params[:group])
    @group.save
    if current_user.is_student?
      redirect_to dashboard_path
    elsif current_user.is_staff?
      respond_with @group
    end
  end

  def edit
    if current_user.is_student?
      @user = current_user
      @badges = current_course.badges
      @assignments = current_course.assignments
    end
    @group = current_course.groups.find(params[:id])
  end

  def update
    @group = current_course.groups.find(params[:id])
    @group.update_attributes(params[:group])
    respond_with @group
  end

  def destroy
    @group = current_course.groups.find(params[:id])
    @group.destroy
    respond_with @group
  end
end
