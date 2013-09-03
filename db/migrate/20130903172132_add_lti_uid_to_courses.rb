class AddLTIUidToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :lti_uid, :string
    add_index :courses, :lti_uid
  end
end
