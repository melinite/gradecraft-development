class AddPointTotalToGrades < ActiveRecord::Migration
  def change
    add_column :grades, :point_total, :integer, index: true
  end
end
