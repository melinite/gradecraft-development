class AddPointTotalToAssignmentWeight < ActiveRecord::Migration
  def change
    add_column :assignment_weights, :point_total, :integer, index: true, null: false, default: 0
  end
end
