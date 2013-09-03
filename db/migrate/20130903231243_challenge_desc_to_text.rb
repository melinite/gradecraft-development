class ChallengeDescToText < ActiveRecord::Migration
  def change
    change_column :challenges, :description, :text
  end
end
