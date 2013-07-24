class ChangeGradeableToStudent < ActiveRecord::Migration
  def change
    remove_reference :grades, :gradeable, :polymorphic => true
    add_reference :grades, :student
  end
end
