class AddLtiUidToCourse < ActiveRecord::Migration
  def change
    add_column :courses, :lti_uid, :string
  end
end
