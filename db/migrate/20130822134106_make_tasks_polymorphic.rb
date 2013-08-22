class MakeTasksPolymorphic < ActiveRecord::Migration
  def change
    rename_column :tasks, :assignment_id, :taskable_id
    add_column :tasks, :taskable_type, :string
  end
end
