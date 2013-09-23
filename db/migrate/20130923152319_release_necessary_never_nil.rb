class ReleaseNecessaryNeverNil < ActiveRecord::Migration
  # George Michael Bluth: I just can't take it off. You'll never understand. 
  # Tobias Fünke: ...I'll never understand? That you can never be nil?
  # [he disrobes, exposing his cut-off jeans] 
  # Tobias Fünke: I'll understand more than you'll... never know. 
  def change
    Assignment.where('release_necessary IS NULL').update_all(release_necessary: false)
    change_column :assignments, :release_necessary, :boolean, null: false, default: false
  end
end
