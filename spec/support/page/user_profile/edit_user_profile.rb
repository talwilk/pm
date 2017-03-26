module Page
  module UserProfile
    class EditUserProfile < Page::Base
      form_resource :update_user_profile_form

      def visit
        super edit_profile_path
      end

      def submit
         click_button 'Save Profile'
      end

      def edit_avatar
        find('#avatar-replace').click
      end

      def show_email
        page.has_text? 'Show email'
      end

      def show_number
        page.has_text? 'Show mobile number'
      end

      def change_avatar
        find('#avatar-replace').click
      end

      def remove_avatar
        find('#remove_avatar').click
      end

      def has_user_is_blank_error?
        page.has_text? 'Fill all required fields(full name).'
      end

      def has_blank_field_notice?
        page.has_text? "can't be blank"
      end

      def has_invalid_facebook_link_error?
        page.has_text? 'Insert proper Facebook link'
      end

      def has_invalid_instagram_link_error?
        page.has_text? 'Insert proper Instagram link'
      end

      def has_invalid_pinterest_link_error?
        page.has_text? 'Insert proper Pinterest link'
      end

      def has_invalid_twitter_link_error?
        page.has_text? 'Insert proper Twitter link'
      end

      def has_invalid_google_plus_link_error?
        page.has_text? 'Insert proper Google+ link'
      end

      def delete_account
        click_link 'Cancel my account'
      end
    end
  end
end
