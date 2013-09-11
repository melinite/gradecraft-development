class AddAssignmentTypeIndexToAssignmentWeights < ActiveRecord::Migration
  def change
    add_index :assignment_weights, [:student_id, :assignment_type_id]
  end
end
