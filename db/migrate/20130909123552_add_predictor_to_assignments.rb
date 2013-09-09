class AddPredictorToAssignments < ActiveRecord::Migration
  def change
    add_column :assignments, :points_predictor_display, :string
  end
end
