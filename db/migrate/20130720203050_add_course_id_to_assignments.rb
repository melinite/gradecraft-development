class AddCourseIdToAssignments < ActiveRecord::Migration
  def change
    add_reference :submissions, :course, index: true
    add_reference :assignment_weights, :course, index: true
    add_reference :categories, :course, index: true
    add_reference :challenge_grades, :course, index: true
    add_reference :grades, :course, index: true
    add_reference :group_memberships, :course, index: true
    add_reference :rubrics, :course, index: true
    add_reference :tasks, :course, index: true
  end
end
