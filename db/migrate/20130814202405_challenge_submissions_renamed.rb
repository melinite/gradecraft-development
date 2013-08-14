class ChallengeSubmissionsRenamed < ActiveRecord::Migration
  def change
    rename_column :challenges, :has_challenge_submissions, :accepts_submissions
    rename_column :assignments, :submissions_allowed, :accepts_submissions
    rename_column :tasks, :title, :name
  end
end
