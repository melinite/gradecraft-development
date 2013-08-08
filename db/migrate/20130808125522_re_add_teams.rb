class ReAddTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.string :name
      t.references :course
      t.integer :rank
      t.integer :score
      t.timestamps
    end
    remove_column :groups, :type
  end
end
