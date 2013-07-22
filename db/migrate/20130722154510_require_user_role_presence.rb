class RequireUserRolePresence < ActiveRecord::Migration
  def change
    change_column :users, :role, :string, :default => "student", :null => false
  end
end
