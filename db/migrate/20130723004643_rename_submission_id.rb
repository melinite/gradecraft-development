class RenameSubmissionId < ActiveRecord::Migration
  def change
    rename_column :grades, :assignment_submission_id, :submission_id
  end
end
