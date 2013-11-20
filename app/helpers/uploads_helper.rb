module UploadsHelper
  def upload_url(directory, model)
    course = "#{current_course.name}.#{current_course.id}"
    course.gsub!(/[^0-9a-z]/i, '.').gsub!(/\.+/, '.')
    assignment = "#{model.name}.#{model.id}"
    assignment.gsub!(/[^0-9a-z]/i, '.').gsub!(/\.+/, '.')
    return "uploads/submission_files/#{course}/#{assignment}/#{Time.new.strftime('%Y.%m.%d.%H.%M.%S')}/${filename}"
  end
end
