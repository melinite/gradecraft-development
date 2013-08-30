class ChangeAtToInt < ActiveRecord::Migration
  def change
    remove_column :submissions, :assignment_type
    add_column :submissions, :assignment_type_id, :integer
  end
end
