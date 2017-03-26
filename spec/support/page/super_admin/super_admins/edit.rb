module Page
  module SuperAdmin
    module SuperAdmins
      class Edit < Page::Base
        form_resource :super_admin

        def initialize(super_admin)
          @super_admin = super_admin
        end

        def visit
          ::Page::SuperAdmin::SuperAdmins::Index.new.visit

          within 'tr', text: @super_admin.email do
            click_link 'Edit'
          end
        end

        def save
          click_button 'Save'
        end
      end
    end
  end
end
