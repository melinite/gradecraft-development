class ChangeCgsToString < ActiveRecord::Migration
  def change
    change_column :challenge_grades, :status, :string
  end
end
