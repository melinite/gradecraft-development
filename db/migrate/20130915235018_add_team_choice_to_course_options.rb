class AddTeamChoiceToCourseOptions < ActiveRecord::Migration
  def change
    add_column :courses, :team_score_average, :boolean
  end
end
