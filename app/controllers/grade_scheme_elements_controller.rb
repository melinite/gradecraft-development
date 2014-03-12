class GradeSchemeElementsController < ApplicationController

  before_filter :ensure_staff?

  def index
    @title = "#{current_course.name} Grading"
    @grade_scheme_elements = current_course.grade_scheme_elements
  end

  # Edit all the grade scheme items for a course
  def mass_edit
    @title = "Edit Grade Scheme"
    @course = current_course
    @grade_scheme_elements = current_course.grade_scheme_elements
  end

  def mass_update
    @course = current_course
    @course.update_attributes(params[:course])
    if @course.save
      redirect_to grade_scheme_elements_path
    end
  end

  def show
    @title = "Course Grade Scheme"
    @grade_scheme_element = current_course.grade_scheme_elements.find(params[:id])
  end

  def new
    @title = "Create a New Grade Scheme Element"
    @grade_scheme_element = current_course.grade_scheme_elements.create(params[:grade_scheme_element])

  end

  def edit
    @title = "Editing Course Grade Scheme"
    @grade_scheme_element = current_course.grade_scheme_elements.find(params[:id])
    @grade_scheme_elements = current_course.grade_scheme_elements
  end

  def create
    @grade_scheme_element = current_course.grade_scheme_elements.new(params[:grade_scheme_element])
    respond_to do |format|
      if @grade_scheme_element.save
        format.html { redirect_to grade_scheme_elements_path }
        format.json { render json: @grade_scheme_element, status: :created, location: @grade_scheme_element }
      else
        format.html { render action: "new" }
        format.json { render json: @grade_scheme_element.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @grade_scheme_element = current_course.grade_scheme_elements.find(params[:id])
    @grade_scheme_elements.update_attributes(params[:grade_scheme_elements])
    respond_with grade_scheme_elements_path
  end

  def destroy
    @grade_scheme_element = current_course.grade_scheme_elements.find(params[:id])
    @grade_scheme_element.destroy

    respond_to do |format|
      format.html { redirect_to grade_scheme_element_path(@grade_scheme_element) }
      format.json { head :ok }
    end
  end
end
