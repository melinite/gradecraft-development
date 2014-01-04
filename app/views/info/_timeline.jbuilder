json.set! :timeline do

  json.set! :headline, current_course.name
  json.set! :type, "default"
  json.set! :text, current_course.formatted_tagline

  json.set! :asset do
    json.set! :media, current_course.media_file
    json.set! :credit, current_course.media_credit
    json.set! :caption, current_course.media_caption
  end

  json.set! :date do
    json.array! @events do |event|
      if event.open_at
        json.startDate event.open_at.strftime("%Y,%m,%d")
      elsif event.due_at
        json.startDate event.due_at.strftime("%Y,%m,%d")
      end
      json.endDate event.due_at.strftime("%Y,%m,%d") if event.due_at
      json.headline event.name
      json.text event.description
      json.set! :asset do
        json.media event.media
        json.thumbnail event.thumbnail
        json.credit event.media_credit
        json.caption event.media_caption
      end
    end
  end
end