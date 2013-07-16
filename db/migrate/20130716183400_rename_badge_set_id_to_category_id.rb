class RenameBadgeSetIdToCategoryId < ActiveRecord::Migration
  def up
    rename_column :assignments, :badge_set_id, :category_id
  end
  def down
    rename_column :assignemnts, :category_id, :badge_set_id
  end
end
