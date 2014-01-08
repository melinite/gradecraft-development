class DisplayInToDo < ActiveRecord::Migration
  def up
    add_column :assignment_types, :include_in_to_do, :boolean, default: true
  end

  def down
    remove_column :assignment_types, :include_in_to_do
  end

end
