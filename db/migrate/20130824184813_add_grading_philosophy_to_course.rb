class AddGradingPhilosophyToCourse < ActiveRecord::Migration
  def change
    add_column :courses, :grading_philosophy, :text
  end
end
