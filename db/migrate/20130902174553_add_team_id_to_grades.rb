class AddTeamIdToGrades < ActiveRecord::Migration
  def change
    add_column :grades, :team_id, :integer
  end
end
