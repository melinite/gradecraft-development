class AddBannerToTeams < ActiveRecord::Migration
  def change
    add_column :teams, :banner, :string
  end
end
