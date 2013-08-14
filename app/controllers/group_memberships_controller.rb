class GroupMembershipsController < ApplicationController

  before_filter :ensure_staff?

  def index
    @groups = current_course.groups.all
    @group_memberships = current_course.group_memberships.all

    respond_to do |format|
      format.html
      format.json { render json: @group_memberships }
    end
  end

end
