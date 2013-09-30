class AddNotifyReleasedToAssignments < ActiveRecord::Migration
  def change
    add_column :assignments, :notify_released, :boolean
  end
end
