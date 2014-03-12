class AssignmentTypesController < ApplicationController

  before_filter :ensure_staff?

  def index
    @title = "#{term_for :assignment_types}"
  end

  def show
    @assignment_type = current_course.assignment_types.find(params[:id])
    @title = "#{@assignment_type.name}"
    @score_levels = @assignment_type.score_levels
  end

  def new
    @title = "Create a New #{term_for :assignment_type}"
    @assignment_type = current_course.assignment_types.new
    @assignment_type.score_levels.build
  end

  def edit
    @assignment_type = current_course.assignment_types.find(params[:id])
    @title = "Editing #{@assignment_type.name}"
  end

  def create
    @assignment_type = current_course.assignment_types.new(params[:assignment_type])
    @assignment_type.save

    respond_to do |format|
      if @assignment_type.save
        format.html { redirect_to @assignment_type }
        format.json { render json: @assignment_type, status: :created, location: @assignment_type }
      else
        format.html { render action: "new" }
        format.json { render json: @assignment_type.errors }
      end
    end
  end

  def update
    @assignment_type = current_course.assignment_types.find(params[:id])
    @assignment_type.update_attributes(params[:assignment_type])

    respond_to do |format|
      if @assignment_type.save
        format.html { redirect_to @assignment_type }
        format.json { render json: @assignment_type, status: :created, location: @assignment_type }
      else
        format.html { render action: "new" }
        format.json { render json: @assignment_type.errors }
      end
    end
  end

  #display all grades for all assignments in an assignment type
  def all_grades
    @assignment_type = current_course.assignment_types.find(params[:id])
    user_search_options = {}
    user_search_options['team_memberships.team_id'] = params[:team_id] if params[:team_id].present?
    @team = current_course.teams.find_by(id: params[:team_id]) if params[:team_id]

  end

  def destroy
    @assignment_type = current_course.assignment_types.find(params[:id])
    @assignment_type.destroy
    redirect_to assignment_types_path
  end
end
