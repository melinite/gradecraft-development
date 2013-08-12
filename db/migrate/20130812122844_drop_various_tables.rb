class DropVariousTables < ActiveRecord::Migration
  def change

    drop_table :assignment_submissions

    drop_table :elements

    drop_table :faqs

    drop_table :themes
  end
end
