class ChartsController < ApplicationController

  def index
  end

  def per_assign
    respond_with @assignments = current_course.assignments.order('name ASC').select {|a| a.grades.released.length > 1}
  end

  def team_grade
    #respond_with @assignments = current_course.assignments.order('name ASC').select {|a| a.grades.released.length > 1}
  end

end
