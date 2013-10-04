class AddPredictedScoreToGrades < ActiveRecord::Migration
  def change
    add_column :grades, :predicted_score, :integer, :null => false, :default => 0
  end
end
