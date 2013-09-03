Rails.application.config.middleware.use OmniAuth::Builder do
  provider :developer unless Rails.env.production?
  provider :lti, :oauth_credentials => { ENV['LTI_CONSUMER_KEY'] => ENV['LTI_CONSUMER_SECRET'] }
  provider :kerberos, uid_field: :username, fields: [ :username, :password ]
end
