class RenameBadgeSetIdToCategoryIdInCourseCategories < ActiveRecord::Migration
  def up
    rename_column :course_categories, :badge_set_id, :category_id
  end
  def down
    rename_column :course_categories, :category_id, :badge_set_id
  end
end
