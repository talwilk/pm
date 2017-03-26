module Page
  module User
    module Authentication
      class SignIn < Page::Base
        form_resource :user

        def visit
          super new_user_session_path
        end

        def submit
          click_button 'Sign in'
        end

        def has_successful_reset_password_notice?
          page.has_text? 'You will receive an email with instructions on how to reset your password in a few minutes.'
        end

        def facebook_sign_in
          find('.provider-facebook').click
        end

        def has_invalid_omniauth_credentials_alert?
          page.has_text? 'Invalid credentials'
        end

        def google_oauth2_sign_in
            find('.provider-google_oauth2 div').click
        end

        def has_unsuccessful_oauth_sign_in_notice?
          page.has_text? 'the account is not connected'
        end

        def has_need_to_login_notice?
          page.has_text? 'You need to sign in or sign up before continuing'
        end

        def has_expired_reopening_token_notice?
          page.has_text? 'Token expired'
        end

        def has_invalid_reopening_token_notice?
          page.has_text? 'Invalid token'
        end
      end
    end
  end
end
