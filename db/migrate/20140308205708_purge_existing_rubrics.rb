class PurgeExistingRubrics < ActiveRecord::Migration
  def change
    drop_table :rubrics
    drop_table :criteria
    drop_table :criteria_levels
    drop_table :criterium_levels
  end
end
