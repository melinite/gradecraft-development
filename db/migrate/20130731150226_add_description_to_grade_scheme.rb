class AddDescriptionToGradeScheme < ActiveRecord::Migration
  def change
    add_column :grade_schemes, :description, :text
  end
end
