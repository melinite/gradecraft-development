class DropChallenges < ActiveRecord::Migration
  def change
    drop_table :challenges
    drop_table :challenge_grades
    drop_table :course_grade_schemes
    drop_table :course_grade_scheme_elements
  end
end
