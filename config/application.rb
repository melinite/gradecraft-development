require File.expand_path('../boot', __FILE__)

require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'sprockets/railtie'

Bundler.require(:default, Rails.env)

module GradeCraft
  class Application < Rails::Application
    config.time_zone = 'America/Detroit'
    config.autoload_paths += %W(#{Rails.root}/lib)
    config.generators do |g|
      g.integration_tool :mini_test
      g.orm :active_record
      g.stylesheets :false
      g.template_engine :haml
      g.test_framework :mini_test, :fixture => false
    end
  end
end
