class CreateRubricGrades < ActiveRecord::Migration
  def change
    create_table :rubric_grades do |t|
      t.string :metric_name
      t.string :metric_description
      t.integer :max_points
      t.integer :order
      t.string :tier_name
      t.string :tier_description
      t.integer :points
      t.integer :submission_id
      t.integer :metric_id
      t.integer :tier_id

      t.timestamps
    end
  end
end
