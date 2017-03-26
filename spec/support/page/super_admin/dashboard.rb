module Page
  module SuperAdmin
    class Dashboard < Page::Base
      def visit
        super super_admin_root_path
      end

      def sign_out
        click_link 'Sign out'
      end

      def has_successful_sign_in_notice?
        page.has_css?('.uk-alert-success')
      end
    end
  end
end
