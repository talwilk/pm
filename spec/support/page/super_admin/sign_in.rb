module Page
  module SuperAdmin
    class SignIn < Page::Base
      form_resource :super_admin

      def visit
        super new_super_admin_session_path
      end

      def submit
        click_button 'Sign in'
      end

      def has_unsuccessful_sign_in_alert?
        page.has_text? 'Invalid email or password'
      end
    end
  end
end
