class AssignmentsController < ApplicationController
  
  before_filter :ensure_staff?, :except => [:feed, :show]

  def index
    @title = "#{term_for :assignment} Index"
  end

  def show
    @assignment = current_course.assignments.find(params[:id])
    @title = @assignment.name
    @groups = @assignment.groups
    user_search_options = {}
    user_search_options['team_memberships.team_id'] = params[:team_id] if params[:team_id].present?
    @team = current_course.teams.find_by(id: params[:team_id]) if params[:team_id]
    @auditing = current_course.students.auditing.includes(:teams).where(user_search_options).alpha
    #used to display an alternate view of the same content
    render :detailed_grades if params[:detailed]
  end

  def new
    @title = "Create a New #{term_for :assignment}"
    @assignment = current_course.assignments.new
  end

  def edit
    @assignment = current_course.assignments.find(params[:id])
    @title = "Editing #{@assignment.name}"
    @assignment_rubrics = current_course.rubric_ids.map do |rubric_id|
      @assignment.assignment_rubrics.where(rubric_id: rubric_id).first_or_initialize
    end
  end

  # Duplicate an assignment - important for super repetitive items like attendance and reading reactions
  def copy
    @assignment = current_course.assignments.find(params[:id])
    new_assignment = @assignment.dup
    new_assignment.save
    redirect_to assignments_path
  end

  def create
    @assignment = current_course.assignments.new(params[:assignment])
    if @assignment.due_at.present? && @assignment.open_at.present? && @assignment.due_at < @assignment.open_at
      flash[:error] = 'Due date must be after open date.'
      render :action => "new", :assignment => @assignment
    end
    respond_to do |format|
      self.check_uploads
      @assignment.assign_attributes(params[:assignment])
      @assignment.assignment_type = current_course.assignment_types.find_by_id(params[:assignment_type_id])
      if @assignment.save
        set_assignment_weights
        format.html { respond_with @assignment }
      else
        respond_with @assignment
      end
    end
  end

  def check_uploads
    if params[:assignment][:assignment_files_attributes]["0"][:filepath].empty?
      params[:assignment].delete(:assignment_files_attributes)
      @assignment.assignment_files.destroy_all
    end
  end

  def update
    @assignment = current_course.assignments.includes(:assignment_score_levels).find(params[:id])
    respond_to do |format|
      self.check_uploads
      @assignment.assign_attributes(params[:assignment])
      @assignment.assignment_type = current_course.assignment_types.find_by_id(params[:assignment_type_id])
      if @assignment.save
        format.html { respond_with @assignment }
      else
        format.html { redirect_to edit_assignment_path(@assignment) }
        format.json { render json: @assignment.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @assignment = current_course.assignments.find(params[:id])
    @assignment.destroy
    redirect_to assignments_url
  end

  # Calendar feed of assignments
  def feed
    @assignments = current_course.assignments
    respond_with @assignments.with_due_date do |format|
      format.ics do
        render :text => CalendarBuilder.new(:assignments => @assignments.with_due_date ).to_ics, :content_type => 'text/calendar'
      end
    end
  end

  # Exporting the grades for a single assignment
  def export_grades
    @assignment = current_course.assignments.find(params[:id])
    respond_to do |format|
      format.html
      format.json { render json: @assignment }
      format.csv { send_data @assignment.gradebook_for_assignment(@assignment) }
      format.xls { send_data @assignment.to_csv(col_sep: "\t") }
    end
  end

  private

  def assignment_params
    params.require(:assignment).permit(:assignment_rubrics_attributes => [:id, :rubric_id, :_destroy])
  end

  def set_assignment_weights
    return unless @assignment.student_weightable?
    @assignment.weights = current_course.students.map do |student|
      assignment_weight = @assignment.weights.where(student: student).first || @assignment.weights.new(student: student)
      assignment_weight.weight = @assignment.assignment_type.weight_for_student(student)
      assignment_weight
    end
    @assignment.save
  end
  
end
