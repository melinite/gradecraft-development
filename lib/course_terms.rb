module CourseTerms
  def self.included(base)
    if base < ActionController::Base
      base.helper_method :term_for
    end
  end

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
