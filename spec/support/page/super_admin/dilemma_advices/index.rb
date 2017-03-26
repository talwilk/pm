module Page
  module SuperAdmin
    module DilemmaAdvices
      class Index < Page::Base
        def visit
          super super_admin_dilemma_advices_path
        end

        def search
          click_button 'Search'
        end

        def has_entry?(dilemma_advice)
          has_css?(:tr, text: "##{dilemma_advice.id}")
        end
      end
    end
  end
end
