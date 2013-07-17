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

class ActiveSupport::TestCase
  extend CustomFabricators

  # Custom fabricator definitions
  #
  # These set up default dependencies for fabricating objects. For example, if
  # we're generating a bunch of assignment types, assignments and grades, we
  # want them all to belong to the same course.
  #
  # Three methods are also defined to use the default dependencies:
  #
  # 1. A method with the same name as the fabricator. The first time it is called it will memoize the fabricated object so subsequent calls will refer to the same instance.
  # 2. A create_* method. This accepts a hash of attributes just like Fabricate, which override the default attributes specified inside the `fabricate` block (and subsequently the default attributes specified in the Fabricator definition.
  # 3. A build_* method. Basically the same as the create_* method, but does not save the fabricated object.

  fabricate :assignment do
    { :assignment_type => assignment_type }
  end

  fabricate :assignment_type do
    { :course => course }
  end

  fabricate :course

  fabricate :grade do
    { :gradeable => student, :assignment => assignment }
  end

  fabricate :student do
    { :courses => [course] }
  end

  fabricate :student_assignment_type_weight do
    { :student => student, :assignment_type => assignment_type }
  end

  fabricate :submission do
    { :task => task, :student => student }
  end

  fabricate :task do
    { :assignment => assignment }
  end

  def create_assignments(count = 2)
    1.upto(count).map { |n| create_assignment(:point_total => 100 + n * 200) }
  end

  def create_grades(count = 2)
    create_assignments(count).map { |assignment| create_grade(:assignment => assignment) }
  end
end
