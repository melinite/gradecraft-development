class ChartsController < ApplicationController

  def index
  end

  def per_assign
    respond_with @assignments = current_course.assignments.order('name ASC').select {|a| a.grades.length > 2}
  end

end
