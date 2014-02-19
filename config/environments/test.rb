GradeCraft::Application.configure do
  config.action_controller.allow_forgery_protection = false
  config.action_mailer.default_url_options = { :host => 'gradecraft:3000' }
  config.action_controller.perform_caching = false
  config.action_dispatch.show_exceptions = false
  config.action_mailer.delivery_method = :test
  config.active_support.deprecation = :stderr
  config.cache_classes = true
  config.eager_load = false
  config.serve_static_assets = true
  config.static_cache_control = "public, max-age=3600"
  config.session_store :cookie_store, key: '_gradecraft_session', :expire_after => 60.minutes
end
