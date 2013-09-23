ENV["RAILS_ENV"] = 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

require 'minitest/autorun'
require 'minitest/rails'

require 'capybara-screenshot/minitest'
require 'capybara/rails'
require 'minitest/capybara'
require 'minitest/matchers'
require 'valid_attribute'

require 'minitest/reporters'
MiniTest::Reporters.use!

require 'support/custom_fabricator_definitions'
require 'support/authentication'

Capybara.current_driver = :webkit

class ActiveSupport::TestCase
  include CustomFabricatorDefinitions
end

class ActionDispatch::IntegrationTest
  include CustomFabricatorDefinitions
  include Capybara::DSL
  include Capybara::Assertions
  include Authentication

  self.use_transactional_fixtures = false

  setup do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.start
  end

  teardown do
    DatabaseCleaner.clean
  end
end
