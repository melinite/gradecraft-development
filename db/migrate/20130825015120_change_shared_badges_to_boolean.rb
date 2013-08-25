class ChangeSharedBadgesToBoolean < ActiveRecord::Migration
  def change
    remove_column :course_memberships, :shared_badges
    add_column :course_memberships, :shared_badges, :boolean
  end
end
