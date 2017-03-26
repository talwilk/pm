module Page
  module Post
    class IndexPost < Page::Base
      def visit
        super blog_posts_path
      end
    end
  end
end
