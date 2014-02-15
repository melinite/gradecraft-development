class CourseEventExport
  include Analytics::Export

  rows_by :events

  set_schema  :username => :username,
              :role => :user_role,
              :page => :page,
              :action => :page_name,
              :date_time => :created_at

  def username(event, index)
    data[:users].detect{ |u| u.id == event.user_id }.try(:username)
  end
end
