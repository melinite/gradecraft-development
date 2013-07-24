require "test_helper"

class TeamTest < ActiveSupport::TestCase
  test "sets type automatically" do
    assert_equal 'Team', Team.new.type
  end
end
