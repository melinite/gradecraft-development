class RemoveExtraType < ActiveRecord::Migration
  def change
    remove_column :grades, :_type
  end
end
