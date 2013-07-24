class RemoveBadgeSetIdFromAssignments < ActiveRecord::Migration
  def change
    remove_column :assignments, :badge_set_id
  end
end
