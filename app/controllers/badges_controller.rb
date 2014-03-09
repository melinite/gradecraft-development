class BadgesController < ApplicationController

  before_filter :ensure_staff?, :except => [:index]

  def index
    if current_user.is_student?
      redirect_to my_badges_path
    end
    @title = "View All #{term_for :badges}"
  end

  def show
    @badge = current_course.badges.find(params[:id])
    @title = @badge.name
    @earned_badges = @badge.earned_badges
    @tasks = @badge.tasks
  end

  def new
    @title = "Create a New #{term_for :badge}"
    @badge = current_course.badges.new
  end

  def edit
    @badge = current_course.badges.find(params[:id])
    @title = "Editing #{@badge.name}"
  end

  def create
    @badge = current_course.badges.new(params[:badge])

    respond_to do |format|
      self.check_uploads
      if @badge.save
        format.html { redirect_to @badge }
        format.json { render json: @badge, status: :created, location: @badge }
      else
        format.html { render action: "new" }
        format.json { render json: @badge.errors, status: :unprocessable_entity }
      end
    end
  end

  

  def update
    @badge = current_course.badges.find(params[:id])

    respond_to do |format|
      self.check_uploads
      if @badge.update_attributes(params[:badge])
        format.html { redirect_to @badge }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @badge.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @badge = current_course.badges.find(params[:id])
    @badge.destroy

    respond_to do |format|
      format.html { redirect_to badges_path }
      format.json { head :ok }
    end
  end

  private

  def check_uploads
    if params[:badge][:badge_files_attributes]["0"][:filepath].empty?
      params[:badge].delete(:badge_files_attributes)
      @badge.badge_files.destroy_all
    end
  end
end
