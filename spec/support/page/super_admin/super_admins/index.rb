module Page
  module SuperAdmin
    module SuperAdmins
      class Index < Page::Base
        def visit
          super super_admin_super_admins_path
        end

        def destroy(super_admin)
          within 'tr', text: super_admin.email do
            click_link 'Delete'
          end
        end

        def bring_back(super_admin)
          within 'tr', text: super_admin.email do
            click_link 'Reactivate User'
          end
        end

        def has_entry?(super_admin)
          has_css?(:tr, text: super_admin.email)
        end
      end
    end
  end
end
