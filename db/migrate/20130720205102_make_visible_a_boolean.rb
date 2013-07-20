class MakeVisibleABoolean < ActiveRecord::Migration
  def change
    remove_column :assignments, :visible, :string
    add_column :assignments, :visible, :boolean, :default => true
  end
end
