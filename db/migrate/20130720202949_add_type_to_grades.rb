class AddTypeToGrades < ActiveRecord::Migration
  def change
    add_column :grades, :_type, :string, :index => true
    add_column :groups, :_type, :string, :index => true
  end
end
