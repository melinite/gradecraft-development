class ChallengesController < ApplicationController

  before_filter :ensure_staff?, :only=>[:new,:edit,:create,:update,:destroy]

  def index
    @title = "View All Challenges"
    @challenges = current_course.challenges
  end

  def show
    @challenge = current_course.challenges.find(params[:id])
    @title = @challenge.name
    @teams = current_course.teams

    respond_to do |format|
      format.html
      format.json { render json: @challenge }
    end
  end

  def new
    @challenge = current_course.challenges.new
    respond_to do |format|
      format.html
      format.json { render json: @challenge }
    end
  end

  def edit
    @challenge = current_course.challenges.find(params[:id])
  end

  def create
    @challenge = current_course.challenges.create(params[:challenge])

    respond_to do |format|
      if @challenge.save
        format.html { redirect_to @challenge, notice: 'Challenge was successfully created.' }
        format.json { render json: @challenge, status: :created, location: @challenge }
      else
        format.html { render action: "new" }
        format.json { render json: @challenge.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @challenge = current_course.challenges.find(params[:id])

    respond_to do |format|
      if @challenge.update_attributes(params[:challenge])
        format.html { redirect_to @challenge, notice: 'Challenge was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @challenge.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @challenge = current_course.challenges.find(params[:id])
    @challenge.destroy

    respond_to do |format|
      format.html { redirect_to challenges_path }
      format.json { head :ok }
    end
  end

end
