class TimelineBuilder

  require 'json_builder'

  attr_accessor :assignments

  def initialize(options = {})
    self.assignments = options[:assignments] if options.key?(:assignments)
  end

  def to_json
    JSONBuilder::Compiler.generate do
    timeline do
      headline 'Course Name'
      type "default"
      text "description"
      asset do
        media '/'
        credit 'New York'
        caption 'NY'
      end
      dates do |date|
        startDate "2011,12,10"
        endDate "2011,12,10"
        headline "assignment.name"
        text "assignment.description"
        tag "assignment.assignment_type"
      end
      eras do |era|
        startDate "2011,12,10"
        endDate "2011,12,10"
        headline "assignment.name"
        text "assignment.description"
      end
      charts do |chart|
        startDate "2011,12,10"
        endDate "2011,12,11"
        headline "Headline Goes Here"
        value "28"
      end
    end
  end
end
end