class CreateGradeFiles < ActiveRecord::Migration
  def change
    create_table :grade_files do |t|
      t.integer :grade_id
      t.string :filename
    end
  end
end
