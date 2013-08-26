GradeCraft::Application.configure do
  config.action_controller.perform_caching = true
  config.action_dispatch.best_standards_support = :builtin
  config.action_mailer.default_url_options = { :host => 'gradecraft:3000' }
  config.action_mailer.delivery_method = :test
  config.action_mailer.perform_deliveries = true
  config.action_mailer.raise_delivery_errors = true
  config.active_support.deprecation = :log
  config.assets.compress = false
  config.assets.debug = true
  config.cache_classes = false
  config.consider_all_requests_local = true
  config.eager_load = false
end
