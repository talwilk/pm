module OmniauthTestHelper
  def valid_facebook_login_setup(email)
    if Rails.env.test?
      OmniAuth.config.test_mode = true
      OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
        provider: 'facebook',
        uid: '123545',
        info: {
          email: email
        },
        credentials: {
          token: '123456',
          expires_at: Time.now + 1.week
        }
      })
    end
  end
  def valid_google_login_setup(email)
    if Rails.env.test?
      OmniAuth.config.test_mode = true
      OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
        provider: 'google_oauth2',
        uid: '123544',
        info: {
        email: email
        },
        credentials: {
        token: '123456',
        expires_at: Time.now + 1.week
         }
      })
    end
  end



end
