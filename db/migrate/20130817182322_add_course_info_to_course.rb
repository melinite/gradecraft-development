class AddCourseInfoToCourse < ActiveRecord::Migration
  def change
    add_column :courses, :office, :string
    add_column :courses, :phone, :string
    add_column :courses, :class_email, :string
    add_column :courses, :twitter_handle, :string
    add_column :courses, :twitter_hashtag, :string
    add_column :courses, :location, :string
    add_column :courses, :office_hours, :string
    add_column :courses, :meeting_times, :text
  end
end
