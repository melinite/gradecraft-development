class AddTimelineOptionToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :use_timeline, :boolean
  end
end
