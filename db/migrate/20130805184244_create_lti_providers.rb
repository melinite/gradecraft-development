class CreateLTIProviders < ActiveRecord::Migration
  def change
    create_table :lti_providers do |t|
      t.string :name
      t.string :uid, index: true, unique: true
      t.string :consumer_key
      t.string :consumer_secret
      t.string :launch_url

      t.timestamps
    end
  end
end
