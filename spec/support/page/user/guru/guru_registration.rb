module Page
  module User
    module Guru
      class GuruRegistration < Page::Base
        form_resource :guru_registration_form

        def visit
          super new_guru_registration_path
        end

        def submit
          click_button 'Apply'
        end

        def has_invalid_email_alert?
          page.has_text? 'is invalid'
        end

        def has_blank_email_alert?
          page.has_text? "can't be blank"
        end

        def has_taken_email_alert?
          page.has_text? 'This email already exists. You can recover your password by clicking reset password.'
        end

        def has_invalid_password_alert?
          page.has_text? 'too short'
        end

        def has_blank_password_alert?
          page.has_text? "can't be blank"
        end

        def has_blank_first_name_alert?
          page.has_text? "can't be blank"
        end

        def has_blank_last_name_alert?
          page.has_text? "can't be blank"
        end
      end
    end
  end
end
