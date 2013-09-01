GradeCraft::Application.configure do
  config.action_controller.default_url_options = { :host => 'gradecraft.com' }
  config.action_controller.perform_caching = true
  config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect'
  config.action_mailer.default_url_options = { :host => 'gradecraft.com' }
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
  config.assets.paths << Rails.root.join('app', 'assets', 'fonts')
  config.assets.precompile += %w( .svg .eot .woff .ttf )
  config.cache_classes = false
  config.cache_store = :dalli_store
  config.consider_all_requests_local = false
  config.eager_load = true
  config.force_ssl = true
  config.i18n.fallbacks = true
  config.log_formatter = ::Logger::Formatter.new
  config.log_level = :info
  config.serve_static_assets = false
end
