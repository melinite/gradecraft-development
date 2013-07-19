class RenameCourseAssignmentTypeWeight < ActiveRecord::Migration
  def change
    rename_column :courses, :default_assignment_type_weight, :default_assignment_weight
  end
end
