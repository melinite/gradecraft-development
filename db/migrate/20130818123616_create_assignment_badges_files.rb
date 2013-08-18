class CreateAssignmentBadgesFiles < ActiveRecord::Migration
  def change
    create_table :assignment_files do |t|
      t.string :filename
      t.integer :assignment_id
    end
    create_table :badge_files do |t|
      t.string :filename
      t.integer :badge_id
    end
    create_table :badge_icons do |t|
      t.string :icon_path
      t.integer :badge_id
    end
  end
end
