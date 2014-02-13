class StudentAcademicHistoriesController < ApplicationController

  before_filter :ensure_staff?

  def index
    @students = current_course.users.students
    @academic_histories = @students.student_academic_history
  end

  def show
    @student = current_course.users.students.find(params[:id])
    @academic_history = @student.student_academic_history
  end

  def new
    @student = current_course.users.students.find(params[:id])
    @academic_history = @student.student_academic_history.new
  end

  def create
    @student = current_course.users.students.find(params[:id])
    @academic_history = @student.student_academic_history.build
  end

  def edit
    @student = current_course.users.students.find(params[:id])
    @academic_history = @student.student_academic_history
  end

  def update
    @student = current_course.users.students.find(params[:id])
    @academic_history.update_attributes(params[:academic_history])
  end

  def destroy
  end

end
