class GroupsController < ApplicationController
  before_filter :ensure_staff?, :only => :index

  def index
    @groups = current_course.groups
  end

  def show
    @group = current_course.groups.find(params[:id])
  end

  def new
    @group = current_course.groups.new
  end

  def create
    @group = current_course.groups.new(params[:group])
    @group.save
    respond_with @group
  end

  def edit
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
