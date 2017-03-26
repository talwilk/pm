module Page
  module User
    class Home < Page::Base
      def visit
        super '/'
      end

      def sign_out
        find('.uk-button-dropdown').click
        click_link 'Sign out'
      end

      def edit_profile
        click_link 'Edit Profile'
      end

      def add_dilemma
        find('.add-dilemma-button').click
      end

      def cancel_account
        click_link 'Cancel my account'
      end

      def resend_token
        within(".confirmation-alert") do
          click_link 'here'
        end
      end

      def has_successful_sign_in_notice?
        page.has_text? 'Signed in successfully'
      end

      def has_unsuccessful_sign_in_alert?
        page.has_text? 'Invalid email or password'
      end

      def has_successful_change_password_notice?
        page.has_text? 'Your password has been changed successfully. You are now signed in.'
      end

      def has_successful_facebook_sign_in_notice?
        page.has_text? 'Successfully authenticated from Facebook account.'
      end

      def has_successful_google_sign_in_notice?
        page.has_text? ''
      end

      def has_unconfirmed_notice?
        page.has_text? 'Your email has not yet been confirmed. A confirmation email can be sent again'
      end

      def has_resend_token_notice?
        page.has_text? 'Your confirmation token has been resent successfully.'
      end

      def has_confirmed_account_notice?
        page.has_text? 'Your email address has been successfully confirmed.'
      end

      def has_modal_confirmation_notice?
        page.has_text? 'Add new dilemma'
      end

      def has_already_confirmed_account_notice?
        page.has_text? 'Email was already confirmed'
      end

      def has_expired_token_notice?
        page.has_text? 'Email needs to be confirmed within 3 days, please request a new one'
      end

      def has_invalid_token_notice?
        page.has_text? 'Confirmation token is invalid'
      end

      def has_expired_reopening_token_notice?
        page.has_text? 'Your token seems to be expired! Please get a new one by sign up form'
      end

      def has_not_possible_to_enter_page_notice?
        page.has_text? 'You are not authorized to perform this action.'
      end

      def has_not_confirmed_or_subscribed_notice?
        page.has_text? 'You cannot create new dilemmas! If you are not confirmed, confirm your account. Check also your subscription.'
      end

      def has_deleted_dilemma_notice?
      page.has_text? 'Your dilemma has been deleted.'
      end

      def has_disabled_country_notice?
        page.has_text? 'Your country is disabled'
      end

      def has_featured_gurus_label?
        page.has_text? 'Trending Gurus'
      end

      def has_sample_dilemmas_label?
        page.has_text? 'The most trending dilemmas'
      end

      def has_trending_dilemmas_label?
        page.has_text? 'Trending Dilemmas'
      end

      def has_load_more_button?
        page.has_css?('.load-more')
      end

      def load_more_dilemmas
        find('.load-more').click
      end

      def show_dilemma
        click_on 'First Dilemma'
      end

      def has_call_to_post_first_dilemma_message?
        page.has_text? 'Post your first Dilemma here'
      end
    end
  end
end
