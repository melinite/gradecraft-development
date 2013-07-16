class AddColumnsToAssignments < ActiveRecord::Migration
  def up
    change_table :assignments do |t|
      t.string :_type
      t.integer :parent_id
      t.string :icon
      t.boolean :can_earn_multiple_times
    end
  end
  def down
    change_table :assignments do |t|
      remove_column :_type
      remove_column :parent_id
      remove_column :icon
      remove_column :can_earn_mulitple_times
    end
  end
end
