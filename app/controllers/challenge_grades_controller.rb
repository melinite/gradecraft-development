class ChallengeGradesController < ApplicationController

  before_filter :ensure_staff?, :only=>[:new,:edit,:create,:update,:destroy]

  def index
    @title = "View All Challenge Grades"
    @challenge_grades_grades = current_course.challenge_grades
  end

  def show
    @challenge_grades_grades = current_course.challenge_grades.find(params[:id])
    @title = @challenge_grades_grades.name

    respond_to do |format|
      format.html
      format.json { render json: @challenge_grades }
    end
  end

  def new
    @challenge_grades = current_course.challenge_grades.new
    respond_to do |format|
      format.html
      format.json { render json: @challenge_grades }
    end
  end

  def edit
    @challenge_grades = current_course.challenge_grades.find(params[:id])
  end

  def mass_edit
    @challenge = current_course.challenges.find(params[:challenge_id])
    @teams = current_course.teams
    @title = "Mass Grade #{@challenge.name}"
    @score_levels = @challenge.score_levels
    @students = current_course.users.students
    @challenge_grades = @teams.map do |t|
      @challenge.challenge_grades.where(:team_id => t).first || @challenge.challenge_grades.new(:team => t, :challenge => @challenge)
    end
  end

  def mass_update
    @team = find_team
    @challenge = current_course.challenges.find(params[:challenge_id])
    if @challenge.update_attributes(params[:challenge])
      redirect_to challenge_path(@challenge)
    else
      redirect_to mass_edit_challenge_challenge_grades_path(@challenge)
    end
  end


  def create
    @challenge_grades = current_course.challenge_grades.create(params[:challenge])

    respond_to do |format|
      if @challenge_grades.save
        format.html { redirect_to @challenge_grades, notice: 'Challenge was successfully created.' }
        format.json { render json: @challenge_grades, status: :created, location: @challenge_grades }
      else
        format.html { render action: "new" }
        format.json { render json: @challenge_grades.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @challenge_grades = current_course.challenge_grades.find(params[:id])

    respond_to do |format|
      if @challenge_grades.update_attributes(params[:challenge])
        format.html { redirect_to @challenge_grades, notice: 'Challenge was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @challenge_grades.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @challenge_grades = current_course.challenge_grades.find(params[:id])
    @challenge_grades.destroy

    respond_to do |format|
      format.html { redirect_to challenges_path }
      format.json { head :ok }
    end
  end

end
