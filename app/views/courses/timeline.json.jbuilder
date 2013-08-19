json.set! :timeline do

  json.set! :headline, current_course.name
  json.set! :type, "default"
  json.set! :text, "description"

  json.set! :asset do
    json.set! :media, "http://yourdomain_or_socialmedialink_goes_here.jpg"
    json.set! :credit, "Credit Name Goes Here"
    json.set! :caption, "Caption text goes here"
  end

  json.set! :date do
    json.array! @assignments do |assignment|
      json.startDate assignment.due_at.utc.strftime("%Y,%m,%d") if assignment.due_at
      json.endDate assignment.due_at.utc.strftime("%Y,%m,%d") if assignment.due_at
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
      json.startDate "2013,9,1"
      json.endDate assignment.due_at.utc.strftime("%Y,%m,%d") if assignment.due_at
      json.headline assignment.name
      json.text assignment.description
      json.tag assignment.assignment_type.name
    end
  end

end