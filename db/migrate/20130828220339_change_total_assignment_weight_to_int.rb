class ChangeTotalAssignmentWeightToInt < ActiveRecord::Migration
  def change
    remove_column :courses, :total_assignment_weight, :string
    add_column :courses, :total_assignment_weight, :integer
  end
end
