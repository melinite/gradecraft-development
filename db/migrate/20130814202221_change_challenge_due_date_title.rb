class ChangeChallengeDueDateTitle < ActiveRecord::Migration
  def change
    rename_column :challenges, :due_date, :due_at
  end
end
