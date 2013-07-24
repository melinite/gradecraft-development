require "test_helper"

class GroupTest < ActiveSupport::TestCase
  test "sets type automatically" do
    assert_equal 'Group', Group.new.type
  end
end
