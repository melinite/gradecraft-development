class ChangeCourseGStoGs < ActiveRecord::Migration
  def change
    rename_column :courses, :course_grade_scheme_id, :grade_scheme_id
  end
end
