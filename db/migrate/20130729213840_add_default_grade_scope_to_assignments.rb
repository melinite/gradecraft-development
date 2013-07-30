class AddDefaultGradeScopeToAssignments < ActiveRecord::Migration
  def change
    Assignment.where(:grade_scope => nil).update_all(:grade_scope => 'Individual')
    change_column :assignments, :grade_scope, :string, :default => 'Individual', :null => false
  end
end
