namespace :fnordmetric do
  desc "Populate FnordMetric with events to simulate user activity"
  task :populate => :environment do
    size = User.count
    loop do
      FNORD_METRIC.event({}.merge(_session: User.offset(rand(size)).limit(1).first.id.to_s, _type: :prediction_event, _namespace: 'gradecraft'))
      sleep(rand)
    end
  end
end
