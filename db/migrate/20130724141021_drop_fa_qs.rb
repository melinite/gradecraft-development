class DropFaQs < ActiveRecord::Migration
  def change
    drop_table :faqs
  end
end
