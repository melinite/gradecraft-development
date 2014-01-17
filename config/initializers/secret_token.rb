GradeCraft::Application.config.secret_key_token = ENV['RAILS_TOKEN'] || 'gradecraft'
GradeCraft::Application.config.secret_key_base = ENV['RAILS_SECRET']
