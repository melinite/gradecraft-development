class AddCategoryIdToAssignment < ActiveRecord::Migration
  def change
    add_column :assignments, :category_id, :integer
  end
end
