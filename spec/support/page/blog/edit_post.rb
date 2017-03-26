module Page
  module Post
    class EditPost < Page::Base
      form_resource :blog_post
      form_field :content, as: :froala

      def visit(id)
        super edit_super_admin_blog_path(id)
      end

      def has_blank_alert?
        page.has_text? "can't be blank"
      end

      def attach_image
        page.attach_file('Cover image', "#{Rails.root}/spec/fixtures/test-image/box.png")
      end

      def submit
        click_button 'Update post'
      end
    end
  end
end
