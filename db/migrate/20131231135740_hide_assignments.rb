class HideAssignments < ActiveRecord::Migration
  def up
    add_column :assignments, :include_in_timeline, :boolean, default: true
    add_column :assignment_types, :include_in_timeline, :boolean, default: true
    add_column :assignments, :include_in_predictor, :boolean, default: true
    add_column :assignment_types, :include_in_predictor, :boolean, default: true
  end

  def down
    remove_column :assignments, :include_in_timeline
    remove_column :assignment_types, :include_in_timeline
    remove_column :assignments, :include_in_predictor
    remove_column :assignment_types, :include_in_predictor
  end
end
