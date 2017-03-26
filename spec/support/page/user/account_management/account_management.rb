module Page
  module User
    module AccountManagement
      class AccountManagement < Page::Base
        form_resource :user

        def visit
          super edit_user_registration_path
        end
      end
    end
  end
end
