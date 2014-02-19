class CoursePredictorExport
  include Analytics::Export

  rows_by :events

  set_schema :username => :username,
             :role => :user_role,
             :student_profile => :student_profile,
             :assignment => :assignment_name,
             :prediction => :score,
             :possible => :possible,
             :date_time => :created_at

  def initialize(loaded_data)
    @usernames = loaded_data[:users].inject({}) do |hash, user|
      hash[user.id] = user.username
      hash
    end
    @assignment_names = loaded_data[:assignments].inject({}) do |hash, assignment|
      hash[assignment.id] = assignment.name
      hash
    end
    super
  end

  def filter(events)
    events.select{ |event| event.event_type == "predictor" }
  end

  def username(event, index)
    @usernames[event.user_id] || "[user id: #{event.user_id}]"
  end

  def assignment_name(event, index)
    @assignment_names[event.assignment_id] || "[assignment id: #{event.assignment_id}]"
  end

  def student_profile(event, index)
    nil
  end
end
