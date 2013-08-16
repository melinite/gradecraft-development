class CreateSubmissionFiles < ActiveRecord::Migration
  def change
    create_table :submission_files do |t|
      t.string :filename, null: false
      t.integer :submission_id, null: false
      t.integer :task_id, null: false
      t.integer :user_id, null: false
      t.integer :course_id, null: false
      t.integer :assignment_id, null: false
      t.integer :assignment_type_id, null: false
    end
  end
end
