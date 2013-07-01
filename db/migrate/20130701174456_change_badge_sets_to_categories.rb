class ChangeBadgeSetsToCategories < ActiveRecord::Migration
  def change
    rename_table :badge_sets, :categories
  end
end
