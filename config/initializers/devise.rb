Devise.setup do |config|

  config.secret_key = ENV['SECRET_KEY_BASE']

  config.mailer_sender = ENV['DEVISE_MAILER_SENDER']

  require 'devise/orm/active_record'
  require 'omniauth-google-oauth2'

  config.omniauth :facebook, ENV['FACEBOOK_AUTH_ID'], ENV['FACEBOOK_AUTH_SECRET'], scope: 'email'
  config.omniauth :google_oauth2, ENV['GOOGLE_OMNIAUTH_ID'], ENV['GOOGLE_OMNIAUTH_SECRET'],{access_type: 'online'}
  config.case_insensitive_keys = [:email]

  config.strip_whitespace_keys = [:email]

  config.skip_session_storage = [:http_auth]

  config.sign_out_all_scopes = false
  config.stretches = Rails.env.test? ? 1 : 10

  config.reconfirmable = true

  config.expire_all_remember_me_on_sign_out = true

  config.allow_unconfirmed_access_for = nil

  config.password_length = 8..72

  config.lock_strategy = :failed_attempts
  config.unlock_keys = [:email]
  config.unlock_strategy = :both
  config.maximum_attempts = 5
  config.unlock_in = 1.hour
  config.last_attempt_warning = true

  config.confirm_within = 72.hours

  config.reset_password_within = 6.hours

  config.sign_out_via = :delete
  config.mailer = 'UserMailer'

  Rails.application.config.to_prepare do
    Devise::SessionsController.layout 'devise'
    Devise::RegistrationsController.layout 'devise'
    Devise::ConfirmationsController.layout 'devise'
    Devise::UnlocksController.layout 'devise'
    Devise::PasswordsController.layout 'devise'
  end
end
