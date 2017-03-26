module Page
  module User
    module Authentication
      class SignUp < Page::Base
        form_resource :user

        def visit
          super new_user_registration_path
        end

        def submit
          click_button 'Sign up'
        end

        def has_invalid_email_alert?
          within '.uk-form' do
            page.has_text? 'is invalid'
          end
        end

        def has_blank_email_alert?
          within '.uk-form' do
            page.has_text? "can't be blank"
          end
        end

        def has_taken_email_alert?
          page.has_text? 'taken'
        end

        def has_invalid_password_alert?
          within '.uk-form' do
            page.has_text? 'too short'
          end
        end

        def has_blank_password_alert?
          within '.uk-form' do
            page.has_text? "can't be blank"
          end
        end

        def facebook_sign_in
          find(".provider-facebook").click
        end

        def google_oauth2_sign_in
          find(".provider-google_oauth2 div").click
        end

        def has_invalid_omniauth_credentials_alert?
          page.has_text? 'Invalid credentials'
        end
      end
    end
  end
end
