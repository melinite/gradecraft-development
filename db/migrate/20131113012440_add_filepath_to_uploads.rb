class AddFilepathToUploads < ActiveRecord::Migration
  def change
    add_column :assignment_files, :filepath, :string
    add_column :submission_files, :filepath, :string
    add_column :grade_files, :filepath, :string
    add_column :badge_files, :filepath, :string
  end
end
