class AddScoreToGrades < ActiveRecord::Migration
  def change
    add_column :grades, :score, :integer
    add_index :grades, :score
  end
end
