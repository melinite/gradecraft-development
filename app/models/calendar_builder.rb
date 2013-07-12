class CalendarBuilder
  attr_accessor :assignments

  def initialize(options = {})
    self.assignments = options[:assignments] if options.key?(:assignments)
  end

  def to_ics
    raise "Must specify assignments!" unless assignments
    ical = []
    ical << "BEGIN:VCALENDAR"
    ical << "VERSION:2.0"
    ical << "PRODID://GradeCraft//GradeCraft.com//EN"
    ical << "CALSCALE:GREGORIAN"
    ical << "METHOD:PUBLISH"
    ical << "X-WR-CALNAME:#{escape_text_value(name)}"
    ical << "X-WR-TIMEZONE:America/Detroit"
    assignments.each do |assignment|
      ical << "BEGIN:Vassignment"
      ical << "DTSTART:#{assignment.open_time.utc.strftime("%Y%m%dT%H%M%SZ")}" if assignment.open_time
      if assignment.close_time
        ical << "DTEND:#{assignment.close_time.utc.strftime("%Y%m%dT%H%M%SZ")}"
      else
        ical << "DURATION:PT1H"
      end
      ical << "UID:#{assignment.id}@gradecraft.com"
      ical << "URL:https://gradecraft.com/cities/#{assignment.city.pretty_name}/#{assignment.venue.pretty_name}/#{assignment.pretty_name}"
      ical << "DTSTAMP:#{assignment.created_at.utc.strftime("%Y%m%dT%H%M%SZ")}"
      ical << "LAST-MODIFIED:#{assignment.updated_at.utc.strftime("%Y%m%dT%H%M%SZ")}"
      ical << "SUMMARY:#{escape_text_value("#{assignment.name} for #{course.name}")}"
      ical << "DESCRIPTION:#{escape_text_value(assignment.description)}"
      ical << "SEQUENCE:0"
      #ical << "Location: #{escape_text_value([assignment.venue.name, assignment.venue.address].compact.join(', '))}"
      ical << "STATUS:CONFIRMED"
      ical << "TRANSP:OPAQUE"
      ical << "END:Vassignment"
    end
    ical << "END:VCALENDAR"
    ical.join("\r\n")
  end

  def escape_text_value(text)
    return '' unless text.present?
    text.gsub(/\n\r?|\r\n?|,|;|\\/) do |match|
      if ["\n", "\r", "\n\r", "\r\n"].include?(match)
        '\\n'
      else
        "\\#{match}"
      end
    end
  end
end
