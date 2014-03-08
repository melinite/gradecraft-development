class CreateMetrics < ActiveRecord::Migration
  def change
    create_table :metrics do |t|
      t.string :name
      t.string :description
      t.integer :max_points
      t.integer :rubric_id
      t.integer :order

      t.timestamps
    end
  end
end
