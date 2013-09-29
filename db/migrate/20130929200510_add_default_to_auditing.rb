class AddDefaultToAuditing < ActiveRecord::Migration
  def change
    change_column :course_memberships, :auditing, :boolean, null: false, default: false
  end
end
