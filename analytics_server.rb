# Show output in foreman logs immediately
$stdout.sync = true

require "fnordmetric"

FnordMetric.namespace :gradecraft do
  # login events
  # login events per student (3-dim)
  # average login frequency (calculated from [1 / time-from-last-login])
  # average login frequency per student (3-dim)
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
  toplist_gauge :predictions_by_user,
    group: "Predictions",
    title: "Predictions by User"

  timeseries_gauge :events_per_minute,
    title: "Events per Minute",
    group: "Events",
    key_nouns: %w(Event Events),
    series: [:all_events, :predictor_set],
    calculate: :sum,
    tick: 60

  gauge :events_per_minute_predictor,
    title: "Events per Minute (predictions)"

  widget "Events",
    title: "Predictions per Minute",
    gauges: [:events_per_minute_predictor],
    type: :timeline,
    width: 100,
    autoupdate: 1

  event :predictor_set do
    puts "Prediction event"
    observe :predictions_by_user, session_key
    incr :events_per_minute_predictor, 1
  end

  event :"*" do
    puts "received event: #{data.inspect}"
    incr :events_per_minute, :all_events, 1
    incr :events_per_minute, data[:_type], 1
  end

end

FnordMetric::Web.new(port: 4242)
FnordMetric::Acceptor.new(:protocol => :tcp, :port => 2323)
FnordMetric::Worker.new
FnordMetric.run
