class RenameCriteriumId < ActiveRecord::Migration
  def change
    rename_table :criteria_levels, :criterium_levels
    rename_column :criterium_levels, :criteria_id, :criterium_id
  end
end
