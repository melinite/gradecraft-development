class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.references :assignment
      t.references :submission
      t.string :title
      t.text :description
      t.datetime :due_at
      t.boolean :accepts_submissions
      t.boolean :group

      t.timestamps
    end
  end
end
