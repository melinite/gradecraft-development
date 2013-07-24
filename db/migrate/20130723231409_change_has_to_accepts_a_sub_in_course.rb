class ChangeHasToAcceptsASubInCourse < ActiveRecord::Migration
  def change
    rename_column :courses, :has_assignment_submissions, :accepts_submissions
  end
end
