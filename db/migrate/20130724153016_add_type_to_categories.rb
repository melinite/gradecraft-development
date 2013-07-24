class AddTypeToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :type, :string, :index => true
  end
end
