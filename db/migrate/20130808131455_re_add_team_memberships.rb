class ReAddTeamMemberships < ActiveRecord::Migration
  def change
    create_table :team_memberships do |t|
      t.references :team
      t.references :student
      t.timestamps
    end
    rename_column :group_memberships, :user_id, :student_id
    add_index :group_memberships, :student_id
  end
end
