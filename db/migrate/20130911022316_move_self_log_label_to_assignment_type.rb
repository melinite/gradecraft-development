class MoveSelfLogLabelToAssignmentType < ActiveRecord::Migration
  def change
    add_column :assignment_types, :student_logged_button_text, :string
    add_column :assignment_types, :student_logged_revert_button_text, :string
    remove_column :assignments, :student_logged_button_text
  end
end
