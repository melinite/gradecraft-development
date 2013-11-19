module UploadsHelper
  def url_scheme(model_name)
    course = current_course.name + @assignment.name
    course.gsub! ' ', '.'
    course.gsub! '..', '.'
    return "uploads/#{model_name}/#{course}/#{Time.new.to_s}/${filename}"
  end
end
