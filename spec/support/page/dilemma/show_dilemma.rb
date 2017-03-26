module Page
  module Dilemma
    class ShowDilemma < Page::Base
      form_resource :dilemma_advice
      form_field :content, as: :froala

      def visit(id)
        super dilemma_path(id)
      end

      def has_successful_create_dilemma_notice?
        page.has_text?('points for posting a Dilemma')
      end

      def has_disabled_dilemma_notice?
        page.has_text?('Dilemma has been already commented!')
      end

      def has_similar_user_dilemmas
        page.has_css?('user_dilemma-0')
      end

      def has_similar_category_dilemmas
        page.has_css?('category_dilemma-0')
      end

      def has_dilemma_advices
        page.has_css?('user_dilemma-advice-0')
      end

      def closed_dilemma
        page.has_text?('Dilemma is closed!')
      end
      def have_content
        page.has_text?('This is a content')
      end

      def remove_dilemma
        click_link('Remove dilemma')
      end

      def edit_dilemma
        click_link('Edit dilemma')
      end

      def can_edit_dilemma
        page.has_link?('Edit dilemma')
      end

      def can_remove_dilemma
        page.has_link?('Remove dilemma')
      end

      def can_not_edit_dilemma
        page.has_no_link?('Edit dilemma')
      end

      def can_not_remove_dilemma
        page.has_no_link?('Remove dilemma')
      end

      def not_set_cover_photo
        page.has_text?('Cover photo is not set')
      end

      def has_successful_update_dilemma_notice?
        page.has_text?('Dilemma was successfully updated.')
      end

      def has_disabled_dilemma_notice?
        page.has_text?('Dilemma has been posted about before.')
      end

      def submit
        find('button[data-cmd="froala-action-button"]').click
      end

      def has_disabled_advice_create_button_notice?
       page.has_no_css?('froala-action-button')
      end

      def has_fill_content_notice?
        page.has_text?("can't be blank")
      end

      def has_successful_create_advice_notice?
        page.has_text?('Advice was created.')
      end

      def choose_file
        find('button[data-cmd="froala-attach-button"]').click
        find('.add-media').hover
        find('.add-image-file').click
      end

      def choose_image_url
        find('button[data-cmd="froala-attach-button"]').click
        find('.add-media').hover
        find('.add-image-url').click
      end

      def choose_youtube_video
        find('.add-media').hover
        find('.add-youtube-url').click
      end

      def add_url
        click_button 'Add URL'
      end

      def browse_file
        click_button 'Browse'
      end

      def attach_image
        page.attach_file('File', "#{Rails.root}/spec/fixtures/test-image/box.png", :visible => '')
      end

      def choose_favorite_advice
        find('.best-advice', match: :first).click
      end

      def has_favorite_advice
        page.has_css?('dilemma-favourite-advice')
      end

      def has_no_favorite_advice_link
        page.has_no_link?('Favourite advice')
      end

      def like
        within('#advice-likes-1') do
          find(".heart").click
        end
      end

      def has_like
        page.has_css?('blank-heart')
      end

      def has_unlike
        page.has_css?('heart')
      end

      def unlike
        within('#advice-likes-1') do
          find(".blank-heart").click
        end
      end

      def has_no_unlike
        within('#advice-likes-1') do
          has_no_link?('Unlike')
        end
      end

      def has_no_like
        within('#advice-likes-1') do
          has_no_link?('Unlike')
        end
      end

      def has_no_like_div
        has_no_css?('#advice-likes-1')
      end

      def has_no_advice_field
        has_no_field?('content')
      end

      def open_share_modal
        find('.dilemma-item__share').click
      end

      def has_meta_tags
        page.find 'meta', visible: false, match: :first
      end

      def has_facebook_share
        page.find '.fb'
      end

      def has_twitter_share
        page.find '.tw'
      end

      def has_google_share
        page.find '.gp'
      end
    end
  end
end
