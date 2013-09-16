class ChangeTaskableToAssignment < ActiveRecord::Migration
  def change
    rename_column :tasks, :taskable_id, :assignment_id
  end
end
