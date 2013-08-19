class RemoveNullFromCourseWeights < ActiveRecord::Migration
  def change
    change_column :courses, :total_assignment_weight, :string, :null => true
    change_column :courses, :max_assignment_weight, :string, :null => true
  end
end
