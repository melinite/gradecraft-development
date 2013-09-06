class AddAssignmentTypeToSubmissions < ActiveRecord::Migration
  def change
    add_column :submissions, :assignment_type, :string
    add_index :submissions, :assignment_type
  end
end
