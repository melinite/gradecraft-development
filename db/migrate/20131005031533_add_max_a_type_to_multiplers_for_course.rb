class AddMaxATypeToMultiplersForCourse < ActiveRecord::Migration
  def change
    add_column :courses, :max_assignment_types_weighted, :integer
  end
end
