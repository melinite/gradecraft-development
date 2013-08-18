# Show output in foreman logs immediately
$stdout.sync = true

require "fnordmetric"

def frequency_in_weeks(last_time, this_time)
  ( 7.days.to_f / (this_time - last_time) ).round(2)
end

FnordMetric.namespace :gradecraft do
  #--------#
  # GAUGES #
  #--------#
  toplist_gauge :events_by_user,
    group: "Events",
    title: "Events by User"

  timeseries_gauge :events_per_minute,
    title: "Events per Minute",
    group: "Events",
    key_nouns: %w(Event Events),
    series: [:all_events, :login, :predictor_set],
    calculate: :sum,
    tick: 1.minute.to_i

  gauge :predictions_per_miniute,
    tick: 1.minute.to_i

  widget "Events",
    title: "Predictions per Minute",
    gauges: [:predictions_per_minute],
    type: :timeline,
    width: 100,
    autoupdate: 1

  # pageviews
  gauge :pageviews_daily_unique, :tick => 1.day.to_i, :unique => true, :title => "Unique Visits (Daily)"
  gauge :pageviews_hourly_unique, :tick => 1.hour.to_i, :unique => true, :title => "Unique Visits (Hourly)"
  gauge :pageviews_monthly_unique, :tick => 40.days.to_i, :unique => true, :title => "Unique Visits (Month)"

  gauge :pageviews_per_url_daily,
    :tick => 1.day.to_i,
    :title => "Daily Pageviews per URL",
    :three_dimensional => true

  gauge :pageviews_per_url_monthly,
    :tick => 30.days.to_i,
    :title => "Monthly Pageviews per URL",
    :three_dimensional => true
  

  # pageviews per student
  gauge :pageviews_per_student_daily,
    :tick => 1.day.to_i,
    :title => "Daily Pageviews per Student",
    :three_dimensional => true

  gauge :pageviews_per_student_monthly,
    :tick => 30.days.to_i,
    :title => "Monthly Pageviews per Student",
    :three_dimensional => true

  # login events
  gauge :logins_per_day,
    tick: 1.day.to_i

  gauge :logins_per_month,
    tick: 30.days.to_i

  # average login frequency (calculated from [1 / time-from-last-login])
  gauge :average_login_frequency,
    tick: 1.week.to_i,
    average: true

  # login events per student (3-dim)
  gauge :logins_per_student_daily,
    tick: 1.day.to_i,
    three_dimensional: true

  # login events per student (3-dim)
  gauge :logins_per_student_monthly,
    tick: 30.days.to_i,
    three_dimensional: true

  # average login frequency per student (3-dim)
  gauge :average_login_frequency_per_student,
    tick: 1.week.to_i,
    three_dimensional: true

  gauge :events,
    tick: 1.day.to_i

  # events per student
  gauge :events_per_user,
    tick: 1.day.to_i,
    three_dimensional: true

  # average prediction scores
  gauge :average_prediction_scores,
    average: true,
    tick: 1.week.to_i

  # average prediction scores per student (3-dim)
  gauge :average_prediction_scores_per_student,
    average: true,
    tick: 1.week.to_i,
    three_dimensional: true

  # average prediction scores per assignment (3-dim)
  gauge :average_prediction_scores_per_assignment,
    average: true,
    tick: 1.week.to_i,
    three_dimensional: true

  #--------#
  # Events #
  #--------#

  event :_pageview do
    incr :pageviews_daily_unique
    incr :pageviews_hourly_unique
    incr :pageviews_monthly_unique
    incr_field :pageviews_per_url_daily, data[:url]
    incr_field :pageviews_per_url_monthly, data[:url]
    incr_field :pageviews_per_user, session_key
    incr_field :pageviews_per_user_monthly, session_key
  end

  event :predictor_set do
    puts "Prediction event"
    incr :predictions_per_minute, 1
    incr :average_prediction_scores, data[:score]
    incr_field :average_prediction_scores_per_student, session_key, data[:score]
    incr_field :average_prediction_scores_per_assignment, data[:assignment_id], data[:score]
  end

  event :login do
    incr :logins_per_day
    incr :logins_per_month
    incr :average_login_frequency, frequency_in_weeks(data[:last_login], timestamp)
    incr_field :logins_per_student_daily, session_key
    incr_field :logins_per_student_monthly, session_key
    incr_field :average_login_frequency_per_student, session_key, frequency_in_weeks(data[:last_login], timestamp)
  end

  event :"*" do
    puts "received event: #{data.inspect}"
    unless %w(_set_name _set_picture).include? data[:_type]
      observe :events_by_user, session_key
      incr :events_per_minute, :all_events, 1
      incr :events_per_minute, data[:_type], 1
      incr :events, 1
      incr_field :events_per_user, session_key, 1
    end
  end

end

FnordMetric::Web.new(port: 4242)
FnordMetric::Acceptor.new(:protocol => :tcp, :port => 2323)
FnordMetric::Worker.new
FnordMetric.run
