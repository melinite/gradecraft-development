class AddDefaultAssignmentTypeWeightToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :default_assignment_type_weight, :decimal, :precision => 4, :scale => 1, :default => 1
  end
end
