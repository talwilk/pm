module Page
  module User
    module Authentication
      class NewPassword < Page::Base
        form_resource :user

        def visit
          super edit_user_password_path
        end

        def submit
          click_button 'Change my password'
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

        def has_invalid_password_confirmation_alert?
          within '.uk-form' do
            page.has_text? "doesn't match"
          end
        end
      end
    end
  end
end
