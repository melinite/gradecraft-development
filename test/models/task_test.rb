require "test_helper"

class TaskTest < ActiveSupport::TestCase
  include ValidAttribute::Method

  test "sets type automatically" do
    assert_equal 'Task', Task.new.type
  end

  test "validates presence of assignment" do
    @task = build_task(:assignment => nil)
    assert_wont have_valid(:assignment).when(nil), @task
    assert_must have_valid(:assignment).when(assignment), @task
  end
end
