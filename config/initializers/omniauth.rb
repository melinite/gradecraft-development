Rails.application.config.middleware.use OmniAuth::Builder do
  provider :developer unless Rails.env.production?
  provider :lti, :oauth_credentials => { 'Caitlin Holman' => 'berlin' }
  provider :kerberos, fields: [ :username, :password ]
end
