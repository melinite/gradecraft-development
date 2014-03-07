class ChangeChallengeGradeFeedbackType < ActiveRecord::Migration
  def change
    add_column :challenge_grades, :text_feedback, :text
  end
end
