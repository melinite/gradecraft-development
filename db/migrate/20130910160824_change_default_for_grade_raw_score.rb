class ChangeDefaultForGradeRawScore < ActiveRecord::Migration
  def change
    change_column :grades, :raw_score, :integer, :default => 0, :null => false
  end
end
