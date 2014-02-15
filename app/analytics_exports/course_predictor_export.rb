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

  def filter(events)
    events.select{ |event| event.event_type == "predictor" }
  end

  def username(event, index)
    data[:users].detect{ |u| u.id == event.user_id }.try(:username) || "[user id: #{event.user_id}]"
  end

  def assignment_name(event, index)
    data[:assignments].detect{ |a| a.id == event.assignment_id }.try(:name) || "[assignment id: #{event.assignment_id}]"
  end

  def student_profile(event, index)
    nil
  end
end
