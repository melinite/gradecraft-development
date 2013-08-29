class ChangeGradedByToGbi < ActiveRecord::Migration
  def change
    rename_column :grades, :graded_by, :graded_by_id
  end
end
