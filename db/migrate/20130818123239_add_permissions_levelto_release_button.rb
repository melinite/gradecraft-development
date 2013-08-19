class AddPermissionsLeveltoReleaseButton < ActiveRecord::Migration
  def change
    add_column :assignments, :role_necessary_for_release, :string
  end
end
