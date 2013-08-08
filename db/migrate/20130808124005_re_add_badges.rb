class ReAddBadges < ActiveRecord::Migration
  def change
    create_table :badges do |t|
      t.string :name
      t.string :description
      t.integer :point_total
      t.references :course
      t.references :assignment
      t.references :badge_set
      t.string :icon
      t.timestamps
    end
    remove_column :assignments, :parent_id
    remove_column :assignments, :type
  end
end
