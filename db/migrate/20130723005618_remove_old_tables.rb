class RemoveOldTables < ActiveRecord::Migration
  def change
    drop_table :assignment_submissions
    drop_table :badges
    drop_table :teams
    drop_table :team_memberships
    drop_table :elements
    drop_table :badge_sets
    drop_table :badge_sets_courses
    drop_table :course_badge_sets
    drop_table :earned_badges
    drop_table :student_assignment_type_weights
  end
end
