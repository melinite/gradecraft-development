class AssignmentsController < ApplicationController
  before_filter :ensure_staff?, :except => [:feed, :show, :index]

  def index
    @title = "#{term_for :assignment} Index"
    @assignments = current_course.assignments
    if current_user.is_student?
      @by_assignment_type = @assignments.group_by(&:assignment_type)
      @sorted_teams = current_course.teams.order_by_high_score
      @scores_for_current_course = current_student.scores_for_course(current_course)
    end
    respond_with @assignments = current_course.assignments.order('name ASC').order('due_at ASC')
  end

   def settings
    @title = "#{term_for :assignments} Settings"
    @assignments = current_course.assignments
    @assignment_types = current_course.assignment_types
    @grade_schemes = current_course.grade_schemes
    respond_to do |format|
      format.html
      format.json { render json: @assignments.as_json(only:[:id, :name, :description, :point_total, :due_at, :assignment_type_id, :grade_scheme_id, :grade_scope, :visible, :required ]) }
    end
  end

  def show
    @assignments = current_course.assignments
    @assignment = @assignments.find(params[:id])
    @title = @assignment.name
    @groups = @assignment.groups
    @team = current_course.teams.find_by(id: params[:team_id]) if params[:team_id]
    if current_user.is_student?
      @scores_for_current_course = current_student.scores_for_course(current_course)
      @by_assignment_type = @assignments.group_by(&:assignment_type)
    end
    @students = @team ? @team.students : current_course.students
    @sorted_teams = current_course.teams.order_by_high_score
    respond_with @assignment
  end

  def new
    @title = "Create a New #{term_for :assignment}"
    @assignment = current_course.assignments.new
    @assignment_types = current_course.assignment_types
    @grade_schemes = current_course.grade_schemes
  end

  def edit
    @assignment = current_course.assignments.find(params[:id])
    @title = "Edit #{@assignment.name}"
    @assignment_rubrics = current_course.rubric_ids.map do |rubric_id|
      @assignment.assignment_rubrics.where(rubric_id: rubric_id).first_or_initialize
    end
  end

  def create
    @assignment = current_course.assignments.new(params[:assignment])
    if @assignment.save
      respond_with @assignment, :location => assignment_path(@assignment), :notice => 'Assignment was successfully created.'
    else
      respond_with @assignment
    end
  end

  def update
    @assignment = current_course.assignments.find(params[:id])
    @assignment.update_attributes(params[:assignment])
    respond_with @assignment
  end

  def destroy
    @assignment = current_course.assignments.find(params[:id])
    @assignment.destroy

    respond_to do |format|
      format.html { redirect_to assignments_url }
      format.json { head :ok }
    end
  end

  def feed
    @assignments = current_course.assignments
    respond_with @assignments.with_due_date do |format|
      format.ics do
        render :text => CalendarBuilder.new(:assignments => @assignments.with_due_date ).to_ics, :content_type => 'text/calendar'
      end
    end
  end

  private

  def assignment_params
    params.require(:assignment).permit(:assignment_rubrics_attributes => [:id, :rubric_id, :_destroy])
  end
end
