module Page
  module Post
    class ShowPost < Page::Base
      def visit(id)
        super blog_post_path(id)
      end
    end
  end
end
