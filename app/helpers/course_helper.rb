module CourseHelper
  def term_for(key)
    case key
    when :student
      current_course.user_term
    else
      key
    end
  end
end
