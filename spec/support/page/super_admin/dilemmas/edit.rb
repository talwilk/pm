module Page
  module SuperAdmin
    module Dilemmas
      class Edit < Page::Base
        form_resource :dilemma
        form_field :description, as: :froala

        def initialize(dilemma)
          @dilemma = dilemma
        end

        def visit
          ::Page::SuperAdmin::Dilemmas::Index.new.visit

          within 'tr', text: "##{@dilemma.id}" do
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

        def remove_dilemma
          click_link 'Remove dilemma'
        end
      end
    end
  end
end
