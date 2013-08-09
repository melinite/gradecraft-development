class AddVisibleToBadges < ActiveRecord::Migration
  def change
    add_column :badges, :visible, :boolean
  end
end
