module CurrentScopes
  def self.included(base)
    base.helper_method :current_user, :current_course, :current_student
  end

  def current_course
    return unless current_user
    @__current_course ||= current_user.courses.find_by(id: session[:course_id]) if session[:course_id]
    @__current_course ||= current_user.default_course
  end

  def current_student
    if current_user.is_staff?
      @__current_student ||= (current_course.students.find_by params[:student_id] if params[:student_id])
    else
      current_user
    end
  end

  def current_student=(student)
    puts "Setting current student"
    @__current_student = student
  end
end
