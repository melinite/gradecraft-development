class RemoveThemes < ActiveRecord::Migration
  def change
    remove_column :courses, :theme_id
    drop_table :themes
  end
end
