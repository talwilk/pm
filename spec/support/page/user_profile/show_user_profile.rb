module Page
  module UserProfile
    class ShowUserProfile < Page::Base
      def visit(id)
        super user_path(id)
      end

      def has_successful_edit_notice?
        page.has_text? 'Account was successfully updated.'
      end

      def has_not_possible_to_enter_page_notice?
        page.has_text? 'You are not allowed to enter this page'
      end

      def has_edit_button?
        page.has_link? 'Edit profile'
      end

      def has_username?
        page.has_css? '.profile-view__username'
      end

      def has_company_field?
        page.has_text? 'Panda'
      end

      def has_address_field?
        page.has_text? 'Wojskowa'
      end

      def has_mantra_field?
        page.has_text? 'Love life'
      end

      def has_unlocked_phone_field?
        page.has_text? '123123123'
      end

      def has_unlocked_email_field?
        page.has_text? 'guru@user.email'
      end

      def has_avatar_removed_notice?
        page.has_text? 'Your avatar was removed successfully'
      end

      def load_more_dilemmas
        page.has_css?('.load-more')
      end

      def choose_user_advices_dilemmas
        click_link "Advices"
      end

      def has_counter_class?
        page.has_css? '.dilemma-item__remaining'
      end
    end
  end
end
