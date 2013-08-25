class AddSharedSettingToEarnedBadge < ActiveRecord::Migration
  def change
    add_column :earned_badges, :shared, :boolean
  end
end
