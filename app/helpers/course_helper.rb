module CourseHelper
  def term_for(key)
    case key
    when :student
      current_course.user_term
    when :weight
      current_course.weight_term
    when :weights
      current_course.weight_term.pluralize
    else
      key
    end
  end
end
