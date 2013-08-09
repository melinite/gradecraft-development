class CalendarBuilder
  attr_accessor :assignments

  def initialize(options = {})
    self.assignments = options[:assignments] if options.key?(:assignments)
  end

  def to_ics
    raise "Must specify assignments!" unless assignments
    ical = []
    ical << "BEGIN:VCALENDAR"
    ical << "METHOD:PUBLISH"
    ical << "VERSION:2.0"
    ical << "PRODID://GradeCraft//GradeCraft.com//EN"
    ical << "CALSCALE:GREGORIAN"
    ical << "X-WR-TIMEZONE:America/Detroit"
    ical << "X-WR-CALNAME: GradeCraft"
    assignments.each do |assignment|
      ical << "BEGIN:VEVENT"
      ical << "DTSTART;TZID=America/New_York::#{assignment.open_time.utc.strftime("%Y%m%dT%H%M%SZ")}" if assignment.open_time
      if assignment.close_time
        ical << "DTEND;TZID=America/New_York::#{assignment.close_time.utc.strftime("%Y%m%dT%H%M%SZ")}"
      else
        ical << "DTSTART;VALUE=DATE:#{assignment.due_at.strftime("%Y%m%d")}"
      end
      ical << "UID:#{assignment.id}@gradecraft.com"
      ical << "URL:https://gradecraft.com/assignments/#{assignment.id}/"
      ical << "DTSTAMP:#{assignment.created_at.utc.strftime("%Y%m%dT%H%M%SZ")}"
      ical << "LAST-MODIFIED:#{assignment.updated_at.utc.strftime("%Y%m%dT%H%M%SZ")}"
      ical << "SUMMARY:#{escape_text_value("#{assignment.course.name}: #{assignment.name}")}"
      ical << "DESCRIPTION:#{escape_text_value(assignment.description)}"
      ical << "SEQUENCE:0"
      ical << "STATUS:CONFIRMED"
      ical << "TRANSP:OPAQUE"
      ical << "END:VEVENT"
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