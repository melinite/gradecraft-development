class RenameCourseMaxAssignmentTypeWeight < ActiveRecord::Migration
  def change
    rename_column :courses, :max_student_assignment_type_weight, :max_assignment_weight
  end
end
