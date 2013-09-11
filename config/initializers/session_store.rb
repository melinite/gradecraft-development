# Be sure to restart your server when you modify this file.

#GradeCraft::Application.config.session_store :cookie_store, key: '_gradeCraft_session', :expire_after => 60.minutes
Rails.application.config.session_store ActionDispatch::Session::CacheStore, :expire_after => 60.minutes
