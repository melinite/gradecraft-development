json.set! :timeline do

  json.set! :headline, current_course.name
  json.set! :type, "default"
  json.set! :text, current_course.tagline

  json.set! :asset do
    json.set! :media, current_course.media_file
    json.set! :credit, current_course.media_credit
    json.set! :caption, current_course.media_caption
  end

  json.set! :date do
    json.array! @assignments do |assignment|
      json.startDate assignment.due_at.strftime("%Y,%m,%d") if assignment.due_at
      json.endDate assignment.due_at.strftime("%Y,%m,%d") if assignment.due_at
      json.headline assignment.name
      json.text assignment.description
      json.tag assignment.assignment_type.name
      json.set! :asset do
        json.media assignment.media
        json.thumbnail assignment.thumbnail
        json.credit assignment.media_credit
        json.caption assignment.media_caption
      end
    end
  end

  json.set! :era do
    json.array! @assignments do |assignment|
      json.startDate "2013,1,9"
      json.endDate assignment.due_at.utc.strftime("%Y,%m,%d") if assignment.due_at
      json.headline assignment.name
      json.text assignment.description
      #json.tag assignment.assignment_type.name
    end
  end

end