class ChangeAssignmentSubmissions < ActiveRecord::Migration
  def change
    rename_table :assignment_submissions, :submissions
    rename_column :submissions, :user_id, :student_id
    add_column :submissions, :creator_id, :integer
    add_column :submissions, :group_id, :integer
    remove_column :submissions, :submittable_id
    remove_column :submissions, :submittable_type
  end
end
