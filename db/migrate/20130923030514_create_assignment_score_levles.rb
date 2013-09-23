class CreateAssignmentScoreLevles < ActiveRecord::Migration
  def change
    create_table :assignment_score_levels do |t|
      t.integer :assignment_id, null: false
      t.string :name, null: false
      t.integer :value, null: false
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false
    end
  end
end
