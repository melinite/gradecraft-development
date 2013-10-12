class GroupsController < ApplicationController
  before_filter :ensure_staff?, :only => :index

  def index
    @groups = current_course.groups
    @title = "#{term_for :group} Index"
  end

  def show
    if current_user.is_student?
      @user = current_user
      @badges = current_course.badges
      @assignments = current_course.assignments
      @by_assignment_type = @assignments.alphabetical.chronological.group_by(&:assignment_type)
      @scores_for_current_course = current_student.scores_for_course(current_course)
      @sorted_teams = current_course.teams.order_by_high_score
    end
    @group = current_course.groups.find(params[:id])
  end

  def new
    @group = current_course.groups.new
  end

  def create
    @group = current_course.groups.new(params[:group])
    @group.students << current_user if current_user.is_student?
    @group.save
    respond_with @group
  end

  def edit
    @group = current_course.groups.find(params[:id])
    if current_user.is_student?
      @student = current_student
      @other_students = current_course.students.where.not(id: @student.id)
      @group.students << current_student
      @badges = current_course.badges
      @assignments = current_course.assignments
      @by_assignment_type = @assignments.alphabetical.chronological.group_by(&:assignment_type)
      @scores_for_current_course = current_student.scores_for_course(current_course)
    end
  end

  def update
    @group = current_course.groups.find(params[:id])
    if current_user.is_student?
      @student = current_student
      @other_students = current_course.students.where.not(id: @student.id)
      @group.students << current_student
      @assignments = current_course.assignments
      @by_assignment_type = @assignments.alphabetical.chronological.group_by(&:assignment_type)
      @scores_for_current_course = current_student.scores_for_course(current_course)
      @group.update_attributes(params[:group])
      respond_with @group
    end
  end

  def destroy
    @group = current_course.groups.find(params[:id])
    @group.destroy
    respond_with @group
  end
end
