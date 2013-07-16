class RenameBadgeSetsCoursesToCourseCategories < ActiveRecord::Migration
  def up
    rename_table :badge_sets_courses, :course_categories
  end
  def down
    rename_table :course_categories, :badge_sets_categories
  end
end
