class AddTaskToGrades < ActiveRecord::Migration
  def change
    add_reference :grades, :task, index: true
  end
end
