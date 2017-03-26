module Page
  module SuperAdmin
    module SuperAdmins
      class New < Page::Base
        form_resource :super_admin

        def visit
          ::Page::SuperAdmin::SuperAdmins::Index.new.visit
          click_link 'New administrator'
        end

        def save
          click_button 'Save'
        end
      end
    end
  end
end
