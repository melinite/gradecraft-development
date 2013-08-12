class AddCanEarnMultipleTimesToBadges < ActiveRecord::Migration
  def change
    add_column :badges, :can_earn_multiple_times, :boolean
  end
end
