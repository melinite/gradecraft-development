class AddCharacterProfileToCourseMembership < ActiveRecord::Migration
  def change
    add_column :course_memberships, :character_profile, :text
  end
end
