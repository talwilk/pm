module Page
  module SuperAdmin
    module DilemmaAdvices
      class Edit < Page::Base
        form_resource :dilemma_advice
        form_field :content, as: :froala

        def initialize(dilemma_advice)
          @dilemma_advice = dilemma_advice
        end

        def visit
          ::Page::SuperAdmin::DilemmaAdvices::Index.new.visit

          within 'tr', text: "##{@dilemma_advice.id}" do
            click_link 'Edit'
          end
        end

        def save
          click_button 'Save'
        end

        def remove_medium(index)
          within '#media-list' do
            find_all('.medium')[index].find('a', text: 'Delete').click
          end
        end

        def remove_dilemma_advice
          click_link 'Remove dilemma advice'
        end
      end
    end
  end
end
