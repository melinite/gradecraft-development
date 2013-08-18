class LetGroupsHaveMultipleAssignments < ActiveRecord::Migration
  def change
    create_table :assignment_groups do |t|
      t.integer :group_id
      t.integer :assignment_id
    end
    add_column :assignments, :media, :string
    add_column :assignments, :thumbnail, :string
    add_column :assignments, :media_credit, :string
    add_column :assignments, :media_caption, :string
  end
end
