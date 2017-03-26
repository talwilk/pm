module Page
  module Post
    class AdminIndexPost < Page::Base
      def visit
        super super_admin_blog_index_path
      end

      def has_successful_created_post_notice?
        page.has_text? 'New post was successfully created!'
      end

      def has_successful_updated_post_notice?
        page.has_text? 'Post was successfully update!'
      end

      def has_successful_delete_post_notice?
        page.has_text? 'Your blog post has been deleted!'
      end

      def choose_delete_link
        page.click_link 'Delete'
      end
    end

  end
end
