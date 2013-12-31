class AddCourseToGse < ActiveRecord::Migration
  def up
    add_column :grade_scheme_elements, :course_id, :integer
  end

  def down
    remove_column :grade_scheme_elements, :course_id
  end

end
