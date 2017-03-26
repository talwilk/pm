module Page
  module SuperAdmin
    module Users
      class Edit < Page::Base
        form_resource :user
        form_field :country_iso, as: :select

        def initialize(user)
          @user = user
        end

        def visit
          ::Page::SuperAdmin::Users::Index.new.visit

          within 'tr', text: @user.email do
            click_link 'Edit'
          end
        end

        def save
          click_button 'Save'
        end

        def grant_user_points
          click_link 'Grant points'
        end

        def sign_in_as_user
          click_link 'Sign in as user'
        end

        def has_successful_grant_points_message?
          page.has_text? 'You have earned points'
        end
      end
    end
  end
end
