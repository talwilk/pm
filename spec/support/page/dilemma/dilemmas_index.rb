module Page
  module Dilemma
    class DilemmasIndex < Page::Base
      def visit
        super dilemmas_path
      end

      def has_featured_gurus_label?
        page.has_text? 'Trending Gurus'
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

      def search
        find('.top-search-input').native.send_keys(:return)
      end

      def has_no_results_message?
        page.has_text? 'No results found'
      end

      def show_dilemma
        click_on 'Sixth Dilemma'
      end
    end
  end
end
