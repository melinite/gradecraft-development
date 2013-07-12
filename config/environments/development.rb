GradeCraft::Application.configure do
  config.cache_classes = false
  
  config.eager_load = false

  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = true

  config.action_mailer.default_url_options = { :host => 'localhost:3000' }
  config.action_mailer.delivery_method = :test
  config.action_mailer.perform_deliveries = true
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.default :charset => "utf-8"

  config.active_support.deprecation = :log

  config.action_dispatch.best_standards_support = :builtin

  config.assets.compress = false
  

  config.assets.debug = true
  
  config.after_initialize do
    Bullet.enable = true
    Bullet.bullet_logger = true
    Bullet.console = true
    Bullet.rails_logger = true
    Bullet.airbrake = true
  end
end
