class SectionLeaderboardSettings < ActiveRecord::Migration
  def up
    add_column :teams, :teams_leaderboard, :boolean, default: false
    add_column :teams, :in_team_leaderboard, :boolean, default: false
  end

  def down
    remove_column :teams, :teams_leaderboard
    remove_column :teams, :in_team_leaderboard
  end
end
