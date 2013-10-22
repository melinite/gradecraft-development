class AddMassGradeTypeToAssignment < ActiveRecord::Migration
  def change
    add_column :assignments, :mass_grade_type, :string
  end
end
