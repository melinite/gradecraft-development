class AddGraderIdToGrade < ActiveRecord::Migration
  def change
    add_column :grades, :graded_by, :integer
  end
end
