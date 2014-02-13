class CategoriesController < ApplicationController

  before_filter :ensure_staff?

  def index
    @title = "Categories"
    @categories = current_course.categories
  end

  def show
    @category = current_course.categories.find(params[:id])
    @title = @category.name
  end

  def new
    @category = current_course.categories.new
    @title = "Create a New Category"
  end

  def edit
    @category = current_course.categories.find(params[:id])
    @title = "Editing #{@category.name}"
  end

  def create
    @category = current_course.categories.new(params[:category])

    respond_to do |format|
      if @category.save
        format.html { redirect_to @category }
        format.json { render json: @category, status: :created, location: @category }
      else
        format.html { render action: "new" }
        format.json { render json: @category.errors }
      end
    end
  end

  def update
    @category = current_course.categories.find(params[:id])

    respond_to do |format|
      if @category.update_attributes(params[:category])
        format.html { redirect_to @category }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @category = current_course.categories.find(params[:id])
    @category.destroy

    respond_to do |format|
      format.html { redirect_to categories_url }
      format.json { head :no_content }
    end
  end
end
