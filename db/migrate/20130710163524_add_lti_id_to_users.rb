class AddLtiIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :lti_uid, :string
  end
end
