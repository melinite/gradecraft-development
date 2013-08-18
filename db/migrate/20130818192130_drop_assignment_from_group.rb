class DropAssignmentFromGroup < ActiveRecord::Migration
  def change
    remove_column :groups, :assignment_id
  end
end
