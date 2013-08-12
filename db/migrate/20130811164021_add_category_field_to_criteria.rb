class AddCategoryFieldToCriteria < ActiveRecord::Migration
  def change
    add_column :criteria, :category, :string, index: true
  end
end
