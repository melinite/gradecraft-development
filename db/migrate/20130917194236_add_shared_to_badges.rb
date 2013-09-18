class AddSharedToBadges < ActiveRecord::Migration
  def change
    add_column :badges, :shared, :boolean, :default => true
  end
end
