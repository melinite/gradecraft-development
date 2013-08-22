class GroupsController < ApplicationController

  before_filter :ensure_staff?

  def index
    @groups = current_course.groups

    respond_to do |format|
      format.html
      format.json { render json: @groups }
    end
  end

  def show
    @group = current_course.groups.find(params[:id])

    respond_to do |format|
      format.html
      format.json { render json: @group }
    end
  end

  def new
    @group = current_course.groups.new
    @assignment = current_course.assignments
    @students = current_course.users.students
    @group_memberships = @group.group_memberships.build(params[:group_memberships])
    @assignments = current_course.assignments.where(:grade_scope => "Group")
    respond_to do |format|
      format.html
      format.json { render json: @group }
    end
  end

  def edit
    @title = "Edit Group"
    @group = current_course.groups.find(params[:id])
    #@group = @assignment.groups.find(params[:id])
    @students = current_course.users.students
    @assignments = current_course.assignments.where(:grade_scope => "Group")
  end

  def create
    @group = current_course.groups.new(params[:group])
    respond_to do |format|
      if @group.save
        format.html { redirect_to groups_path, notice: 'Group was successfully created.' }
        format.json { render json: @group, status: :created, location: @group }
      else
        format.html { render action: "new" }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    #@assignment = current_course.assignments.find(params[:assignment_id])
    @group = current_course.groups.find(params[:id])
    @group.update_attributes(params[:group])

    respond_to do |format|
      if @group.update_attributes(params[:group])
        format.html { redirect_to groups_path, notice: 'Group was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @group = Group.find(params[:id])
    @group.destroy

    respond_to do |format|
      format.html { redirect_to groups_path }
      format.json { head :ok }
    end
  end
end
