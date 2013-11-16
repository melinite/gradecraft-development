class AddPointTotalToCourse < ActiveRecord::Migration
  def up
    add_column :courses, :point_total, :integer
    add_column :courses, :in_team_leaderboard, :boolean
  end
end
