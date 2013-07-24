class AddTypeToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :assignment_type, :string
    add_column :tasks, :type, :string
    add_index :tasks, [:id, :type]
    add_index :tasks, [:assignment_id, :assignment_type]
  end
end
