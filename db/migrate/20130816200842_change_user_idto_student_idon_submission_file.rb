class ChangeUserIdtoStudentIdonSubmissionFile < ActiveRecord::Migration
  def change
    rename_column :submission_files, :user_id, :student_id
  end
end
