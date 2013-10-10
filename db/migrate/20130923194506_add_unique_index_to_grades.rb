class AddUniqueIndexToGrades < ActiveRecord::Migration
  def change
    add_index :grades, [:assignment_id, :task_id, :submission_id], :unique => true
  end
end
