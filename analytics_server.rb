# Show output in foreman logs immediately
$stdout.sync = true

require "fnordmetric"

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

  # login events
  gauge :logins_per_day,
    tick: 1.day.to_i

  # average login frequency (calculated from [1 / time-from-last-login])
  gauge :average_login_frequency,
    tick: 1.week.to_i,
    average: true

  # login events per student (3-dim)
  gauge :logins_per_day_per_student,
    tick: 1.day.to_i,
    three_dimensional: true

  # average login frequency per student (3-dim)
  gauge :average_login_frequency_per_student,
    tick: 1.week.to_i,
    three_dimensional: true

  # prediction events per student
  # prediction scores per student per assignment (3-dim)
  # average prediction scores
  # average prediction scores per assignment
  # average prediction scores per student
  # average prediction scores
  # average prediction scores per assignment
  # average prediction scores per student
  # pageviews
  # pageviews per student

  #--------#
  # Events #
  #--------#

  event :predictor_set do
    puts "Prediction event"
    incr :predictions_per_minute, 1
  end

  event :"*" do
    puts "received event: #{data.inspect}"
    observe :events_by_user, session_key
    incr :events_per_minute, :all_events, 1
    incr :events_per_minute, data[:_type], 1
  end

end

FnordMetric::Web.new(port: 4242)
FnordMetric::Acceptor.new(:protocol => :tcp, :port => 2323)
FnordMetric::Worker.new
FnordMetric.run
