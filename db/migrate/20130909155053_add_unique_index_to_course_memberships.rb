class AddUniqueIndexToCourseMemberships < ActiveRecord::Migration
  def change
    add_index :course_memberships, [:course_id, :user_id], unique: true
  end
end
