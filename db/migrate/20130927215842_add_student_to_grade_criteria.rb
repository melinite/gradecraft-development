class AddStudentToGradeCriteria < ActiveRecord::Migration
  def change
    add_reference :grade_criteria, :student, index: true
  end
end
