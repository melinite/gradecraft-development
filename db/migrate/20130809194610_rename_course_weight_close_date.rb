class RenameCourseWeightCloseDate < ActiveRecord::Migration
  def change
    rename_column :courses, :assignment_weight_close_date, :assignment_weight_close_at
  end
end
