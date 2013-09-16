GradeCraft::Application.configure do
  config.action_controller.default_url_options = { :host => 'staging.gradecraft.com' }
  config.action_controller.perform_caching = true
  config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect'
  config.action_mailer.default_url_options = { :host => 'staging.gradecraft.com' }
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    :authentication => :plain,
    :address => 'smtp.mandrillapp.com',
    :port => 587,
    :domain => 'gradecraft.com',
    :user_name => ENV['MANDRILL_USERNAME'],
    :password => ENV['MANDRILL_PASSWORD']
  }
  config.active_support.deprecation = :notify
  config.assets.compile = false
  config.assets.compress = true
  config.assets.css_compressor = :sass
  config.assets.digest = true
  config.assets.js_compressor = :uglifier
  config.cache_classes = true
  config.cache_store = :dalli_store
  config.consider_all_requests_local = false
  config.eager_load = true
  config.force_ssl = true
  config.i18n.fallbacks = true
  config.log_formatter = ::Logger::Formatter.new
  config.log_level = :info
  config.serve_static_assets = false
  config.session_store ActionDispatch::Session::CacheStore, :expire_after => 60.minutes
end

Sidekiq.configure_server do |config|
  config.redis = { :url => ENV['REDIS_URL'], :namespace => 'gradecraft_staging' }
end

Sidekiq.configure_client do |config|
  config.redis = { :url => ENV['REDIS_URL'], :namespace => 'gradecraft_staging' }
end
