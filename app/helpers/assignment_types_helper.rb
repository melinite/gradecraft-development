module AssignmentTypesHelper

  #Displays how much the assignment type is worth in the list view
  def value_label
    if percentage_course?
      percentage_course.to_s << "%"
    elsif max_value?
      max_value.to_s << " possible points"
    elsif student_weightable?
      "#{course.user_term.pluralize} decide!"
    else
      "#{total_points} possible points"
    end
  end

end