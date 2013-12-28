class GradeSchemeElementsController < ApplicationController

  before_filter :ensure_staff?

  def index
    @title = "#{@grade_scheme.name} Grading"
    @grade_scheme_elements = current_course.grade_scheme.elements
  end

  def show
    @title = "#{@grade_scheme.name} Grading"
    @grade_scheme_element = current_course.grade_scheme.elements.find(params[:id])
  end

  def new
    @title = "Create a New #{@grade_scheme.name} Grading Element"
    @button_title = "Create"
    @grade_scheme_element = current_course.grade_scheme.elements.create(params[:grade_scheme_element])

  end

  def edit
    @title = "Editing #{@grade_scheme.name} Grading Element"
    @button_title = "Update"
    @grade_scheme_element = current_course.grade_scheme.elements.find(params[:id])
  end

  def create
    @grade_scheme_element = current_course.grade_scheme.elements.new(params[:grade_scheme_element])
    respond_to do |format|
      if @grade_scheme_element.save
        format.html { redirect_to @grade_scheme, notice: 'Grade Scheme Element was successfully created.' }
        format.json { render json: @grade_scheme_element, status: :created, location: @grade_scheme_element }
      else
        format.html { render action: "new" }
        format.json { render json: @grade_scheme_element.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @grade_scheme_element = current_course.grade_scheme.elements.find(params[:id])
    @grade_scheme_element.update_attributes(params[:grade_scheme_element])
    respond_with @grade_scheme
  end

  def destroy
    @grade_scheme_element = current_course.grade_scheme.elements.find(params[:id])
    @grade_scheme_element.destroy

    respond_to do |format|
      format.html { redirect_to grade_scheme_path(@grade_scheme), notice: 'Grade Scheme Element was successfully deleted.' }
      format.json { head :ok }
    end
  end
end
