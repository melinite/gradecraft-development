# Show output in foreman logs immediately
$stdout.sync = true

require "fnordmetric"

FnordMetric.namespace :gradecraft do
  toplist_gauge :predictions_by_user,
    group: "Predictions",
    title: "Predictions by User"

  timeseries_gauge :predictions_per_second,
    title: "Predictions per Second",
    group: "Predictions",
    key_nouns: %w(Prediction Predictions),
    series: [:by_users],
    flush_interval: 1,
    tick: 1

  timeseries_gauge :events_per_minute,
    title: "Events per Minute",
    group: "Events",
    key_nouns: %w(Event Events),
    series: [:all_events, :prediction_event],
    tick: 60

  event :prediction_event do
    puts "Prediction event"
    observe :predictions_by_user, session_key
    incr :predictions_per_second, :by_users, 1
  end

  event :"*" do
    puts "received event: #{data.inspect}"
    incr :events_per_minute, :all_events, 1
    incr :events_per_minute, data[:_type], 1
  end

end

FnordMetric.standalone
