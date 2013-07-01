class ChangeNotesToDescriptionInCategories < ActiveRecord::Migration
  def up
    rename_column :categories, :notes, :description
    change_column :categories, :description, :text
  end

  def down
    rename_column :categories, :description, :notes
    change_column :categories, :description, :string
  end
end
