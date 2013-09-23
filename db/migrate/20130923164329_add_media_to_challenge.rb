class AddMediaToChallenge < ActiveRecord::Migration
  def change
    add_column :challenges, :media, :string
    add_column :challenges, :thumbnail, :string
    add_column :challenges, :media_credit, :string
    add_column :challenges, :media_caption, :string
  end
end
