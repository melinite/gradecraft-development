class AddGroupTypeToGroupMemberships < ActiveRecord::Migration
  def change
    add_column :group_memberships, :group_type, :string
    add_index :group_memberships, [:group_id, :group_type]
  end
end
