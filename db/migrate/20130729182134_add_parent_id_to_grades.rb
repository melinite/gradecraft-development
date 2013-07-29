class AddParentIdToGrades < ActiveRecord::Migration
  def change
    add_column :grades, :parent_id, :integer, index: true
  end
end
