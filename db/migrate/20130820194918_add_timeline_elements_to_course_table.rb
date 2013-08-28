class AddTimelineElementsToCourseTable < ActiveRecord::Migration
  def change
    add_column :courses, :media_file, :string
    add_column :courses, :media_credit, :string
    add_column :courses, :media_caption, :string
  end
end
