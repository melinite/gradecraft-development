class AddRoleToCourseMembership < ActiveRecord::Migration
  def up
    add_column :course_memberships, :role, :string, null: false, default: "student"
  end

  def down
    drop_column :course_memberships, :role, :string
  end
end
