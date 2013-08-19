class DropFieldsOnSubmissionFile < ActiveRecord::Migration
  def change
    remove_column :submission_files, :task_id
    remove_column :submission_files, :student_id
    remove_column :submission_files, :assignment_id
    remove_column :submission_files, :assignment_type_id
    remove_column :submission_files, :course_id
  end
end
