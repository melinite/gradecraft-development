class RenameScoreOnCourseMembership < ActiveRecord::Migration
  def change
    rename_column :course_memberships, :sortable_score, :score
    CourseMembership.where(:score => nil).update_all(:score => 0)
    change_column :course_memberships, :score, :integer, :null => false, :default => 0
  end
end
