class ChangePredictorDescToText < ActiveRecord::Migration
  def change
    change_column :assignment_types, :predictor_description, :text
  end
end
