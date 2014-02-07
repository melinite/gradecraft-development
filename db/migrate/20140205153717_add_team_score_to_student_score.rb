class AddTeamScoreToStudentScore < ActiveRecord::Migration
  def change
    add_column :courses, :add_team_score_to_student, :boolean, default: false
  end
end
