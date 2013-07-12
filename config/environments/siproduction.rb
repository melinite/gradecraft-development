GradeCraft::Application.configure do
  config.cache_classes = false

  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  config.serve_static_assets = false

  config.assets.compress = true
  
  config.assets.compile = false

  config.assets.digest = true

  config.action_mailer.default_url_options = { :host => 'grade-tracker.herokuapp.com' }
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.perform_deliveries = true
  config.action_mailer.raise_delivery_errors = false
  config.action_mailer.default :charset => "utf-8"

  ActionMailer::Base.smtp_settings = {
    :address        => 'smtp.sendgrid.net',
    :port           => '587',
    :authentication => :plain,
    :user_name      => ENV['SENDGRID_USERNAME'],
    :password       => ENV['SENDGRID_PASSWORD'],
    :domain         => 'herokuapp.com'
  }
  ActionMailer::Base.delivery_method = :smtp

  config.force_ssl = true

  config.i18n.fallbacks = true

  config.active_support.deprecation = :notify
end
