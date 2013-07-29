require 'test_helper'

class SubmissionTest < ActiveSupport::TestCase
  test "ungraded returns only ungraded submissions" do
    @ungraded = create_submission(:graded => false, :task => create_task)
    @graded = create_submission(:graded => true, :task => create_task)
    @submissions = assignment.submissions.ungraded
    assert_includes @submissions, @ungraded
    refute_includes @submissions, @graded
  end

  #update, delete, and view permissions

  #grading status

end
