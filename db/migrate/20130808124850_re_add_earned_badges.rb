class ReAddEarnedBadges < ActiveRecord::Migration
  def change
    create_table :earned_badges do |t|
      t.references :badge
      t.references :submission
      t.references :course
      t.references :student
      t.references :task
      t.references :grade
      t.references :group, polymorphic: true
      t.integer :score
      t.text :feedback
      t.timestamps
    end
    remove_column :grades, :parent_id
  end
end
