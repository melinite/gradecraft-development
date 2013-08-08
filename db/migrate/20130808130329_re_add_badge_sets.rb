class ReAddBadgeSets < ActiveRecord::Migration
  def change
    create_table :badge_sets do |t|
      t.string :name
      t.references :course
      t.text :description
      t.timestamps
    end
    remove_column :categories, :type
  end
end
