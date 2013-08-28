env :PATH, ENV['PATH']
set :output, 'log/cron.log'

Time.zone = 'America/Detroit'

every 1.day, :at => Time.zone.parse('12:00am').utc do
  rake 'backup'
end
