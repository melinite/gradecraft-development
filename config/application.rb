require File.expand_path('../boot', __FILE__)

require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'csv'
require 'sprockets/railtie'
require 'sanitize'

Bundler.require(:default, Rails.env)

module GradeCraft
  class Application < Rails::Application
    config.time_zone = 'America/Detroit'
    config.autoload_paths += %W(#{Rails.root}/lib)
    config.assets.precompile += %w(.svg .eot .otf .woff .ttf)
    config.assets.paths << Rails.root.join("app", "assets", "fonts")
    config.filter_parameters += [:password]
    config.active_record.schema_format = :sql
    config.i18n.enforce_available_locales = true
    config.generators do |g|
      g.integration_tool :mini_test
      g.orm :active_record
      g.stylesheets :false
      g.template_engine :haml
      g.test_framework :mini_test
    end
  end
end
