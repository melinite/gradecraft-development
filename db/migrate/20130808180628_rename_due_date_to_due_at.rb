class RenameDueDateToDueAt < ActiveRecord::Migration
  def change
    rename_column :assignments, :due_date, :due_at
  end
end
