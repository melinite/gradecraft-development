class AddLastLoginAtToCourseMemberships < ActiveRecord::Migration
  def change
    add_column :course_memberships, :last_login_at, :datetime
  end
end
