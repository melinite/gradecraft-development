class AddColumnToChallenges < ActiveRecord::Migration
  def change
    add_column :challenges, :open_at, :datetime
    add_column :assignments, :accepts_submissions_until, :datetime
    rename_column :assignments, :open_date, :open_at
    add_column :assignments, :accepts_resubmissions_until, :datetime
    add_column :grades, :admin_notes, :text
    add_column :assignments, :grading_due_at, :datetime
    add_column :courses, :tagline, :string
    add_column :courses, :academic_history_visible, :boolean
  end
end
