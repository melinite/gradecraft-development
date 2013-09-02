class CreateGradeCriteria < ActiveRecord::Migration
  def change
    create_table :grade_criteria do |t|
      t.references :criterium, index: true
      t.references :rubric, index: true
      t.references :course, index: true
      t.references :assignment, index: true
      t.references :criterium_level, index: true

      t.timestamps
    end
  end
end
