class AddPredictedScoreToGrades < ActiveRecord::Migration
  def change
    add_column :grades, :predicted_score, :integer
  end
end
