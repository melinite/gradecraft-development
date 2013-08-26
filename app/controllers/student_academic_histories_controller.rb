class StudentAcademicHistoriesController < ApplicationController

  def index
    @students = current_course.users.students
    @academic_histories = @students.student_academic_history
  end

  def show
    @user = User.find(params[:id])
    @academic_history = @user.student_academic_history
  end

  def new
    @user = User.find(params[:id])
    @academic_history = @user.student_academic_history.new
  end

  def create
    @user = User.find(params[:id])
    @academic_history = @user.student_academic_history.build
  end

  def edit
    @user = User.find(params[:id])
    @students = @users.students
  end

  def update
    @user = User.find(params[:id])
    @academic_history.update_attributes(params[:academic_history])
  end

  def destroy
  end

end
