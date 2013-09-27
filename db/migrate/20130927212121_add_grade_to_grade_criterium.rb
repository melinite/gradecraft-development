class AddGradeToGradeCriterium < ActiveRecord::Migration
  def change
    add_reference :grade_criteria, :grade, index: true
    remove_column :grade_criteria, :criterium_level_id
    add_column :grade_criteria, :score, :integer, null: false, default: 0
  end
end
