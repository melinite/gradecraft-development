require 'test_helper'

class SubmissionTest < ActiveSupport::TestCase
  test "ungraded returns only ungraded submissions" do
    @ungraded = create_submission(:status => 'Ungraded')
    @graded = create_submission(:status => 'Graded')
    @submissions = assignment.submissions.ungraded
    assert_includes @submissions, @ungraded
    refute_includes @submissions, @graded
  end

  #update, delete, and view permissions

  #grading status

end
