class CourseUserAggregateExport
  include Analytics::Export

  rows_by :users

  set_schema :username => :username,
             :total_pageviews => :pageviews,
             :total_logins => :logins,
             :total_predictor_events => :predictor_events,
             :total_predictor_sessions => :predictor_sessions

  def pageviews(user, i)
    data[:user_pageviews].detect { |up| up.user_id == user.id }.pages._all.all_time
  end

  def logins(user, i)
    data[:user_logins].detect { |ul| ul.user_id == user.id }.all_time.count
  end

  def predictor_events(user, i)
    data[:events].count { |event|
      event.user_id == user.id && event.event_type == "predictor"
    }
  end

  def predictor_sessions(user, i)
    data[:user_page_pageviews].detect { |upp|
      upp.user_id == user.id && upp.page == "/dashboard#predictor"
    }.all_time
  end
end
