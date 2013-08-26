module CourseTerms
  def self.included(base)
    base.helper_method :term_for if base < ActionController::Base
  end

  def term_for(key, fallback = nil)
    case key.to_sym
    when :student then current_course.user_term
    when :weight, :assignment, :badge, :team, :group
      current_course.send("#{key}_term")
    when :challenge then "#{term_for(:team)} #{current_course.challenge_term}"
    when :assignment_type then "#{term_for(:assignment)} Type"
    when :students, :weights, :assignments, :assignment_types, :teams, :badges, :challenges, :groups
      term_for(key.to_s.singularize).pluralize
    else
      fallback.presence || raise("No term defined for :#{key}! Please define one in lib/course_terms.rb.")
    end
  end
end
