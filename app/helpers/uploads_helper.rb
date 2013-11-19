module UploadsHelper
  def url_scheme(model_name)
    course = current_course.name + @assignment.name
    course.gsub! '/[^0-9a-z]/i', '.'
    return "uploads/#{model_name}/#{course}/#{Time.new.strftime('%Y.%m.%d.%H.%M.%S')}/${filename}"
  end
end
