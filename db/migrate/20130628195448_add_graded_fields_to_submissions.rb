class AddGradedFieldsToSubmissions < ActiveRecord::Migration
  def change
    add_column :submissions, :graded, :boolean
    add_column :submissions, :released_at, :datetime
  end
end
