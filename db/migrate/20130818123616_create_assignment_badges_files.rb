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
    create_table :challenge_files do |t|
      t.string :filename
      t.integer :challenge_id
    end
  end
end
