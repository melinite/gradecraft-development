class DropAssignRubrics < ActiveRecord::Migration
  def change
    drop_table :assignment_rubrics
  end
end
