class AddDefaultVisible < ActiveRecord::Migration
  def change
    change_column :badges, :visible, :boolean, default: true
    change_column :badges, :can_earn_multiple_times, :boolean, default: true
    change_column :assignments, :visible, :boolean, default: true
    change_column :assignments, :include_in_timeline, :boolean, default: true
    change_column :assignments, :include_in_predictor, :boolean, default: true
    change_column :challenges, :visible, :boolean, default: true
  end
end
