class AddGradingToChallenges < ActiveRecord::Migration
  def change
    add_column :challenges, :mass_grade, :boolean
    add_column :challenges, :mass_grade_type, :string
    add_column :challenges, :levels, :boolean
  end
end
