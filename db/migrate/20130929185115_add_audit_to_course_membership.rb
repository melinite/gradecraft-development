class AddAuditToCourseMembership < ActiveRecord::Migration
  def change
    add_column :course_memberships, :auditing, :boolean
  end
end
