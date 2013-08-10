class MakeRubricsMoreFlexible < ActiveRecord::Migration
  def change
    remove_column :rubrics, :assignment_id
    add_reference :rubrics, :category, index: true
    create_table :assignment_rubrics do |t|
      t.references :assignment, index: true
      t.references :rubric, index: true
      t.timestamps
    end
    create_table :rubric_categories do |t|
      t.references :rubric
      t.string :name
    end
  end
end
