class AddCharacterProfileToCourse < ActiveRecord::Migration
  def change
    add_column :courses, :character_profiles, :boolean
  end
end
