class AddCustomTermsToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :badge_term, :string
    add_column :courses, :assignment_term, :string
    add_column :courses, :challenge_term, :string
  end
end
