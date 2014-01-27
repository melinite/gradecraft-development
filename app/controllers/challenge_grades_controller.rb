class ChallengeGradesController < ApplicationController

  before_filter :ensure_staff?, :except => [:show]

  def index
    @title = "View All #{term_for :challenge} Grades"
    @challenge = current_course.challenges.find(params[:challenge_id])
    @challenge_grades = current_course.challenge_grades
  end

  def show
    @challenge = current_course.challenges.find(params[:challenge_id])
    @challenge_grade = @challenge.challenge_grades.find(params[:id])
    @title = @challenge_grade.name
  end

  def new
    @challenge = current_course.challenges.find(params[:challenge_id])
    @team = current_course.teams.find(params[:team_id])
    @teams = current_course.teams
    @challenge_grade = @team.challenge_grades.new
    @title = "Create a New #{term_for :challenge} Grade"
  end

  def edit
    @challenge = current_course.challenges.find(params[:challenge_id])
    @title = "Editing #{@challenge.name} Grade"
    @teams = current_course.teams
    @challenge_grade = @challenge.challenge_grades.find(params[:id])
  end

  def mass_edit
    @challenge = current_course.challenges.find(params[:challenge_id])
    @teams = current_course.teams
    @title = "Quick Grade #{@challenge.name}"
    @score_levels = @challenge.score_levels
    @students = current_course.users.students
    @challenge_grades = @teams.map do |t|
      @challenge.challenge_grades.where(:team_id => t).first || @challenge.challenge_grades.new(:team => t, :challenge => @challenge)
    end
  end

  def mass_update
    @challenge = current_course.challenges.find(params[:id])
    if @challenge.update_attributes(params[:challenge])
      redirect_to challenge_path(@challenge)
    else
      redirect_to mass_edit_challenge_challenge_grades_path(@challenge)
    end
  end


  def create
    @challenge = current_course.challenges.find(params[:challenge_id])
    @challenge_grades = @challenge.challenge_grades.create(params[:challenge_grade])

    respond_to do |format|
      if @challenge_grades.save
        format.html { redirect_to @challenge, notice: 'Challenge was successfully created.' }
        format.json { render json: @challenge, status: :created, location: @challenge_grades }
      else
        format.html { render action: "new" }
        format.json { render json: @challenge_grades.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @challenge = current_course.challenges.find(params[:challenge_id])
    @challenge_grade = current_course.challenge_grades.find(params[:id])
    respond_to do |format|
      if @challenge_grade.update_attributes(params[:challenge_grade])
        format.html { redirect_to @challenge, notice: 'Challenge was successfully updated.' }
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
