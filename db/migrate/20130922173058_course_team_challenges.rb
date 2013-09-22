class CourseTeamChallenges < ActiveRecord::Migration
  def change
    add_column :courses, :team_challenges, :boolean
  end
end
