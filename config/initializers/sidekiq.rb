Sidekiq.configure_server do |config|
  config.server_middleware do |chain|
    chain.add Kiqstand::Middleware
  end
  config.redis = { :url => ENV['REDIS_URL'], :namespace => 'gradecraft' }
end

Sidekiq.configure_client do |config|
  config.redis = { :url => ENV['REDIS_URL'], :namespace => 'gradecraft' }
end
