class ChangeBdToText < ActiveRecord::Migration
  def change
    change_column :badges, :description, :text
  end
end
