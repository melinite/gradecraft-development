class ChangeMaxAwToInt < ActiveRecord::Migration
  def change
    remove_column :courses, :max_assignment_weight, :string
    add_column :courses, :max_assignment_weight, :integer
  end
end
