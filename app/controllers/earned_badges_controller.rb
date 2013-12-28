class EarnedBadgesController < ApplicationController

  before_filter :ensure_staff?, :except => :toggle_shared

  def index
    @badge = current_course.badges.find(params[:badge_id])
    redirect_to badge_path(@badge)
  end

  def my_badges
    @title = "Awarded #{term_for :badges}"
    @earned_badges = @earnable.earned_badges
  end

  def show
    @title = "Awarded #{term_for :badge}"
    @badge = current_course.badges.find(params[:badge_id])
    @earned_badge = @badge.earned_badges.find(params[:id])
  end

  def new
    @title = "Award a New #{term_for :badge}"
    @badges = current_course.badges
    @badge = @badges.find(params[:badge_id])
    @earned_badge = @badge.earned_badges.new
    @students = current_course.users.students.alpha
  end

  def new_via_student
    @title = "Award a New #{term_for :badge}"
    @badges = current_course.badges
    @earned_badge = @badge.earned_badges.new
    @students = current_course.users.students
  end

  def new_via_assignment
    @title = "Award a New #{term_for :badge}"
    @assignments = current_course.assignments
    @badges = current_course.badges
    @earned_badge = @earnable.earned_badges.new
  end

  def toggle_shared
    @earned_badge = current_course.earned_badges.where(:badge_id => params[:badge_id], :student_id => current_student.id).first
    @earned_badge.shared = !@earned_badge.shared
    @earned_badge.save
    render :json => {
      :shared => @earned_badge.shared
    }
  end

  def edit
    @title = "Editing Awarded #{term_for :badge}"
    @students = current_course.students
    @badge = current_course.badges.find(params[:badge_id])
    @earned_badge = @badge.earned_badges.find(params[:id])
    respond_with @earned_badge
  end


  def create
    @badges = current_course.badges
    @badge = @badges.find(params[:badge_id])
    @earned_badge = @badge.earned_badges.build(params[:earned_badge])
    respond_to do |format|
      if @earned_badge.save
        format.html { redirect_to badge_path(@badge), notice: 'Badge was successfully awarded.' }
      else
        format.html { render action: "new" }
        format.json { render json: @earned_badge.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @badges = current_course.badges
    @badge = current_course.badges.find(params[:badge_id])
    @earned_badge = @badge.earned_badges.find(params[:id])

    respond_to do |format|
      if @earned_badge.update_attributes(params[:earned_badge])
        format.html { redirect_to student_path(@earned_badge.student), notice: 'Awarded badge was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @earned_badge.errors, status: :unprocessable_entity }
      end
    end
  end

  def mass_edit
    @badge = current_course.badges.find(params[:id])
    @title = "Mass Award #{@badge.name}"
    @team = current_course.teams.find_by(id: params[:team_id]) if params[:team_id]
    user_search_options = {}
    user_search_options['team_memberships.team_id'] = params[:team_id] if params[:team_id].present?
    @students = current_course.students.includes(:teams).where(user_search_options).alpha
    @earned_badges = @students.map do |s|
      @badge.earned_badges.where(:student_id => s).first || @badge.earned_badges.new(:student => s, :badge => @badge)
    end
  end

  def mass_update
    @badge = current_course.badges.find(params[:id])
    if @badge.update_attributes(params[:badge])
      respond_with @badge
    else
      @title = "Quick Award #{@badge.name}"
      user_search_options = {}
      user_search_options['team_memberships.team_id'] = params[:team_id] if params[:team_id].present?
      @students = current_course.users.students.includes(:teams).where(user_search_options).alpha
      @earned_badges = @students.map do |s|
        @badge.earned_badges.where(:student_id => s).first || @badge.earned_badges.new(:student => s)
      end
    end
  end

  def chart
    @badges = current_course.badges
    @students = current_course.users.students
  end

  def destroy
    @badge = current_course.badges.find(params[:badge_id])
    @earned_badge = @badge.earned_badges.find(params[:id])
    @earned_badge.destroy
    redirect_to @badge
  end

end
