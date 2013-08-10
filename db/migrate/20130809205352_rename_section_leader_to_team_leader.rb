class RenameSectionLeaderToTeamLeader < ActiveRecord::Migration
  def change
    rename_column :courses, :section_leader_term, :team_leader_term
  end
end
