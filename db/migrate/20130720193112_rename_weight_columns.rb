class RenameWeightColumns < ActiveRecord::Migration
  def change
    rename_column :courses, :total_student_weight, :total_assignment_weight
    Course.where('max_assignment_weight IS NULL').update_all(:max_assignment_weight => 0)
    change_column :courses, :max_assignment_weight, :integer, :null => false
    rename_column :courses, :student_weight_type, :assignment_weight_type
    rename_column :courses, :student_weight_close_date, :assignment_weight_close_date
    rename_column :courses, :multiplier_term, :weight_term
    remove_column :courses, :multiplier_default, :decimal
  end
end
