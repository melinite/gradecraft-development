class CourseEventExport
  include Analytics::Export

  rows_by :events

  set_schema  :username => :username,
              :role => :user_role,
              :page => :page,
              :action => :page_name,
              :date_time => :created_at

  def initialize(loaded_data)
    @usernames = loaded_data[:users].inject({}) do |hash, user|
      hash[user.id] = user.username
      hash
    end
    super
  end

  def username(event, index)
    @usernames[event.user_id] || "[user id: #{event.user_id}]"
  end

  def page(event, index)
    event.try(:page) || "[n/a]"
  end

  def page_name(event, index)
    nil
  end
end
