class AddFilepathToChallengeFiles < ActiveRecord::Migration
  def change
    add_column :challenge_files, :filepath, :string
  end
end
