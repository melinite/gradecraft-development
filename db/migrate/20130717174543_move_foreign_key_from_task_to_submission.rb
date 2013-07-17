class MoveForeignKeyFromTaskToSubmission < ActiveRecord::Migration
  def change
    add_column :submissions, :task_id, :integer
    remove_column :tasks, :submission_id, :integer
  end
end
