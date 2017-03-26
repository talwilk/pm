module Page
  module User
    module Authentication
      class ResetPassword < Page::Base
        form_resource :user

        def visit
          super new_user_password_path
        end

        def submit
          click_button 'Reset Password'
        end

        def has_invalid_email_alert?
          within '.uk-form' do
            page.has_text? 'not found'
          end
        end
      end
    end
  end
end
