class CreateRubrics < ActiveRecord::Migration
  def change
    create_table :rubrics do |t|
      t.integer :assignment_id

      t.timestamps
    end
  end
end
