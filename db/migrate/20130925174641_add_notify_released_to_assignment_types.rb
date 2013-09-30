class AddNotifyReleasedToAssignmentTypes < ActiveRecord::Migration
  def change
    add_column :assignment_types, :notify_released, :boolean
  end
end
