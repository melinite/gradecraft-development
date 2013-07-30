class AddAssignmentTypeToGrades < ActiveRecord::Migration
  def change
    add_reference :grades, :assignment_type, index: true
  end
end
