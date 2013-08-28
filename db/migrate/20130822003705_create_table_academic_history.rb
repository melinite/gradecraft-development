class CreateTableAcademicHistory < ActiveRecord::Migration
  def change
    create_table :student_academic_histories do |t|
      t.integer :student_id
      t.string :major
      t.decimal :gpa
      t.integer :current_term_credits
      t.integer :accumulated_credits
      t.string :year_in_school
      t.string :state_of_residence
      t.string :high_school
      t.boolean :athlete
      t.integer :act_score
      t.integer :sat_score
    end
  end
end
