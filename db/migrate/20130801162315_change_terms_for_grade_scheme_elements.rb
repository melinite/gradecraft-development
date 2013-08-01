class ChangeTermsForGradeSchemeElements < ActiveRecord::Migration
  def change
    rename_column :grade_scheme_elements, :name, :level
    rename_column :grade_scheme_elements, :letter_grade, :letter
  end
end
