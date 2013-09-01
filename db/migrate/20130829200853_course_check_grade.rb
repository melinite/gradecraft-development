class CourseCheckGrade < ActiveRecord::Migration
  def change
    add_column :courses, :check_final_grade, :boolean
  end
end
