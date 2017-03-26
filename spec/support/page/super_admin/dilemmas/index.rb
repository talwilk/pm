module Page
  module SuperAdmin
    module Dilemmas
      class Index < Page::Base
        def visit
          super super_admin_dilemmas_path
        end

        def search
          click_button 'Search'
        end

        def has_entry?(dilemma)
          has_css?(:tr, text: "##{dilemma.id}")
        end
      end
    end
  end
end
