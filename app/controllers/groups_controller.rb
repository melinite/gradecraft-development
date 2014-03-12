class GroupsController < ApplicationController
  before_filter :ensure_staff?, :only => :index

  def index
    @groups = current_course.groups
    @assignments = current_course.assignments.group_assignments
    @title = current_course.group_term.pluralize
  end

  def show
    if current_user.is_student?
      @user = current_user
    end
    @group = current_course.groups.find(params[:id])
    @assignments = current_course.assignments.group_assignments
  end

  def new
    @group = current_course.groups.new
    @assignments = current_course.assignments.group_assignments
    @title = "Start a #{term_for :group}"
  end

  def create
    @group = current_course.groups.new(params[:group])
    @assignments = current_course.assignments.group_assignments
    @group.students << current_user if current_user.is_student?
    @group.save
    respond_with @group
  end

  def edit
    @group = current_course.groups.find(params[:id])
    @assignments = current_course.assignments.group_assignments
    @title = "Editing #{@group.name} Details"
    if current_user.is_student?
      @student = current_student
      @group.students << current_student
    end
  end

  def update
    @group = current_course.groups.find(params[:id])
    if current_user.is_student?
      @student = current_student
      @group.students << current_student
    end
    @group.update_attributes(params[:group])
    respond_with @group
  end

  def destroy
    @group = current_course.groups.find(params[:id])
    @group.destroy
    respond_with @group
  end
end
