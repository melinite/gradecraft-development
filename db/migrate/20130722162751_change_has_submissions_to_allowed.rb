class ChangeHasSubmissionsToAllowed < ActiveRecord::Migration
  def change
    rename_column :assignments, :has_assignment_submissions, :submissions_allowed
  end
end
