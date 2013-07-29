class AddGroupToGrade < ActiveRecord::Migration
  def change
    add_reference :grades, :group, polymorphic: true, index: true
  end
end
