require 'test_helper'

class AssignmentTest < ActiveSupport::TestCase
  
  test "assignment attributes must not be empty" do assignment = Assignment.new
    assert assignment.invalid?
    assert assignment.errors[:name].any?
  end

end
