class AddReusbmissionsToAssignments < ActiveRecord::Migration
  def change
    add_column :assignments, :resubmissions_allowed, :boolean
    add_column :assignments, :max_submissions, :integer
  end
end
