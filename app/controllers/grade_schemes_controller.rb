class GradeSchemesController < ApplicationController

  before_filter :ensure_prof?

  def index
    @title = "Grading Schemes"
    @grade_schemes = current_course.grade_schemes
    if current_user.is_admin?
      @grade_schemes = current_course.grade_schemes
    end
  end

  def show
    @grade_scheme = current_course.grade_schemes.find(params[:id])
    @title = "#{@grade_scheme.name}"
    @grade_scheme_elements = @grade_scheme.elements.order_by_low_range
  end

  def new
    @grade_scheme = current_course.grade_schemes.new
    @assignments = current_course.assignments
    @title = "Create a New Grading Scheme"
  end

  def edit
    @grade_scheme = current_course.grade_schemes.find(params[:id])
    @assignments = current_course.assignments
    @title = "Edit #{@grade_scheme.name}"
  end

  def create
    @grade_scheme = current_course.grade_schemes.new(params[:grade_scheme])
    @assignments = current_course.assignments
    @grade_scheme.save
    respond_with @grade_scheme
  end

  def destroy_multiple
    @grade_schemes = current_course.grade_schemes.find(params[:grade_scheme_ids])
    @grade_schemes.delete

    respond_to do |format|
      format.html { redirect_to grade_schemes_url }
      format.json { head :ok }
    end
  end

  def update
    @grade_scheme = current_course.grade_schemes.find(params[:id])
    @assignments = current_course.assignments
    respond_to do |format|
      if @grade_scheme.update_attributes(params[:grade_scheme])
        format.html { redirect_to @grade_scheme, notice: 'Grade scheme was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @grade_scheme.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @grade_scheme = current_course.grade_schemes.find(params[:id])
    @grade_scheme.destroy

    respond_to do |format|
      format.html { redirect_to grade_schemes_url }
      format.json { head :ok }
    end
  end

end
