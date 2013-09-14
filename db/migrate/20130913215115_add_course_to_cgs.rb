class AddCourseToCgs < ActiveRecord::Migration
  def change
    add_column :course_grade_schemes, :course_id, :integer
  end
end
