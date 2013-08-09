ENV["RAILS_ENV"] = 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

require 'minitest/autorun'
require 'minitest/rails'
require 'minitest/matchers'

require 'minitest/reporters'
MiniTest::Reporters.use!

require 'valid_attribute'
require 'support/custom_fabricators'

require 'minitest/capybara'
require 'capybara/rails'
require 'capybara-screenshot/minitest'

Capybara.javascript_driver = :webkit

module CustomFabricatorDefinitions
  include CustomFabricators

  # Custom fabricator definitions
  #
  # These set up default dependencies for fabricating objects. For example, if
  # we're generating a bunch of assignment types, assignments, and grades, we
  # want them all to belong to the same course.
  #
  # Three methods are also defined to use the default dependencies:
  #
  # 1. A method with the same name as the fabricator. The first time it is
  # called it will memoize the define_custom_fabricatord object so subsequent
  # calls will refer to the same instance.
  #
  # 2. A create_* method. This accepts a hash of attributes just like
  # define_custom_fabricator, which override the default attributes specified
  # inside the `define_custom_fabricator` block (and subsequently the default
  # attributes specified in the Fabricator definition.
  #
  # 3. A build_* method. Basically the same as the create_* method, but does
  # not save the fabricated object.

  define_custom_fabricator :assignment do
    { :assignment_type => assignment_type }
  end

  define_custom_fabricator :assignment_type do
    { :course => course }
  end

  define_custom_fabricator :badge do
    { :badge_set => badge_set }
  end

  define_custom_fabricator :badge_set do
    { :course => course }
  end

  define_custom_fabricator :course

  define_custom_fabricator :grade do
    { :student => student, :assignment => assignment }
  end

  define_custom_fabricator :grade_scheme do
    { :course => course }
  end

  define_custom_fabricator :grade_scheme_element do
    { :grade_scheme => grade_scheme }
  end

  define_custom_fabricator :earned_badge do
    { :student => student, :badge => badge }
  end

  define_custom_fabricator :student do
    { :courses => [course] }
  end

  define_custom_fabricator :professor do
    { :courses => [course] }
  end

  define_custom_fabricator :assignment_weight do
    { :student => student, :assignment => assignment }
  end

  define_custom_fabricator :submission do
    { :assignment => assignment, :student => student }
  end

  define_custom_fabricator :task do
    { :assignment => assignment }
  end

  def create_assignments(count = 2)
    1.upto(count).each do |n|
      create_assignment(:point_total => 100 + n * 200)
    end
  end

  def create_grades(count = 2)
    1.upto(count).each do |n|
      create_assignment(:point_total => 100 + n * 200) do
        create_grade(:raw_score => n * 200)
      end
    end
  end
end

class ActiveSupport::TestCase
  include CustomFabricatorDefinitions
end

class ActionDispatch::IntegrationTest
  include CustomFabricatorDefinitions
  include Capybara::DSL
  include Capybara::Assertions
end
