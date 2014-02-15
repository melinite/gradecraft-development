class CoursePredictorExport
  include Analytics::Export

  rows_by :events

  set_schema :username => :username,
             :role => :user_role,
             :student_profile => nil,
             :assignment => :assignment_name,
             :prediction => :score,
             :possible => :possible,
             :date_time => :created_at

  def username(event, index)
    data[:users].detect{ |u| u.id == event.user_id }.try(:username)
  end

  def assignment_name(event, index)
    data[:assignments].detect{ |a| a.id == event.assignment_id }.try(:name)
  end
end
