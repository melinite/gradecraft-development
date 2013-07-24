class AddPrivacySettingToGrades < ActiveRecord::Migration
  def change
    add_column :grades, :shared, :boolean
  end
end
