class RenameStudentAssignmentTypeWeight < ActiveRecord::Migration
  def change
    rename_table :student_assignment_type_weights, :assignment_weights
    change_column :assignment_weights, :student_id, :integer, :null => false
    change_column :assignment_weights, :assignment_type_id, :integer, :null => false
    add_column :assignment_weights, :assignment_id, :integer, :null => false
    add_index :assignment_weights, :assignment_id
    add_index :assignment_weights, [:student_id, :assignment_id], name: "index_weights_on_student_id_and_assignment_id", unique: true, using: :btree
  end
end
