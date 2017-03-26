module Page
  module SuperAdmin
    module Users
      class Index < Page::Base
        def visit
          super super_admin_users_path
        end

        def search
          click_button 'Search'
        end

        # def destroy(super_admin)
        #   within 'tr', text: super_admin.email do
        #     click_link 'Destroy'
        #   end
        # end
        #
        # def bring_back(super_admin)
        #   within 'tr', text: super_admin.email do
        #     click_link 'Bring back'
        #   end
        # end

        def has_entry?(user)
          has_css?(:tr, text: user.email)
        end
      end
    end
  end
end
