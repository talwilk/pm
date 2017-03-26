module Page
  module Dilemma
    class EditDilemma < Page::Base
      form_resource :dilemma
      form_field :description, as: :froala

      def visit(id)
        super edit_dilemma_path(id)
      end

      def open_categories
        page.find('.select2-search__field').click
      end

      def choose_category(category)
        click_link(category)
      end

      def has_unsuccessful_update_dilemma_notice?
        page.has_text?("can't be blank")
      end

      def choose_file
        find('.add-media').hover
        find('.add-image-file').click
      end

      def choose_image_url
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

      def add_file
        click_button 'Add file'
      end

      def browse_file
        click_button 'Browse'
      end

      def attach_image
        page.attach_file('File', "#{Rails.root}/spec/fixtures/test-image/box.png", :visible => '')
      end

      def submit
        click_button 'Update Dilemma'
      end

      def cancel
        click_button 'Cancel'
      end

      def remove_media
        click_link('Remove media', match: :first)
      end

      def change_cover
        click_link('Set as cover', match: :first)
      end
    end
  end
end
