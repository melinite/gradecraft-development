class CoursesController < ApplicationController

  before_filter :ensure_staff?, :except => :timeline

  def index
    @title = "Course Index"
    @courses = Course.all

    respond_to do |format|
      format.html
      format.json { render json: @courses }
    end
  end

  def show
    @title = "Course Settings"
    @course = current_course
    @users = current_course.users
    respond_to do |format|
      format.html
      format.json { render json: @course }
    end
  end

  def new
    @title = "Create a New Course"
    @course = Course.new
    @badge_sets = BadgeSet.all
    @grade_schemes = GradeScheme.all

    respond_to do |format|
      format.html
      format.json { render json: @course }
    end
  end

  def edit
    @title = "Edit Basic Settings"
    @course = Course.find(params[:id])
    @grade_schemes = GradeScheme.all
    @badge_sets = BadgeSet.all
    @grade_schemes = GradeScheme.all

  end

  def create
    @course = Course.new(params[:course])
    @badge_sets = BadgeSet.all

    respond_to do |format|
      if @course.save
        format.html { redirect_to @course, notice: 'Course was successfully created.' }
        format.json { render json: @course, status: :created, location: @course }
      else
        format.html { render action: "new" }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @course = Course.find(params[:id])

    respond_to do |format|
      if @course.update_attributes(params[:course])
        format.html { redirect_to @course, notice: 'Course was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @course = Course.find(params[:id])
    @course.destroy

    respond_to do |format|
      format.html { redirect_to courses_url }
      format.json { head :no_content }
    end
  end

  def assignments
    @course = current_course
    @assignments = EventSearch.new(:current_user => current_user, :events => @course.events).find
    respond_with @assignments do |format|
      format.ics do
        render :text => CalendarBuilder.new(:assignments => @assignments).to_ics, :content_type => 'text/calendar'
      end
    end
  end

  def timeline
    @course = current_course
    if current_course.team_challenges?
      @events = @course.assignments + @course.challenges
    else
      @events = @course.assignments
    end
  end
end
