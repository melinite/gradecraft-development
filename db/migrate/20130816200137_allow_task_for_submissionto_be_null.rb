class AllowTaskForSubmissiontoBeNull < ActiveRecord::Migration
  def change
    change_column :submission_files, :task_id, :string, :null => true
  end
end
