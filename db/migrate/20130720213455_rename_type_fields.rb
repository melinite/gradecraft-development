class RenameTypeFields < ActiveRecord::Migration
  def change
    rename_column :assignments, :_type, :type
    rename_column :groups, :_type, :type
  end
end
