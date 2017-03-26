module Page
  module Dilemma
    class AddDilemma < Page::Base
      form_resource :dilemma
      form_field :description, as: :froala

      def visit
        super new_dilemma_path
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

      def browse_file
        click_button 'Browse'
      end

      def has_unsuccessful_create_dilemma_notice?
        page.has_text?("can't be blank")
      end

      def attach_image
        page.attach_file('File', "#{Rails.root}/spec/fixtures/test-image/box.png", :visible => '')
      end

      def submit
        click_button 'Publish Your Dilemma'
      end

      def cancel
        page.find('.uk-close').click
        click_button 'Cancel'
      end

      def has_remove_input_link?
        page.has_css?('.remove-media', :visible => false)
      end

      def open_categories
        page.find('.select2-search__field').click
      end

      def choose_category(category)
        page.find('li', :text => category).click
      end
    end
  end
end
