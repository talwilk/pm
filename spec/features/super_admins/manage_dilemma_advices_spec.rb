require 'rails_helper'

feature 'Super admin visits dilemma advices tab' do
  let!(:super_admin)    { create :super_admin }
  let!(:dilemma_advice) { create(:dilemma_advice, content: 'Content') }
  let!(:second_media)   { create(:file, mediable: dilemma_advice) }
  let(:index_page)      { Page::SuperAdmin::DilemmaAdvices::Index.new }
  let(:edit_page)       { Page::SuperAdmin::DilemmaAdvices::Edit.new(dilemma_advice) }

  before do
    sign_in(super_admin)
  end

  scenario 'and uses search bar' do
    index_page.visit
    expect(index_page).to have_text("##{dilemma_advice.id}")

    index_page.fill_in 'search', with: dilemma_advice.content + 'x'
    index_page.search
    expect(index_page).to have_content 'No results found'

    index_page.fill_in 'search', with: dilemma_advice.content
    index_page.search
    expect(index_page).to have_content 'Search results: (1)'
    expect(index_page).to have_content "##{dilemma_advice.id}"
  end

  scenario 'edits dilemma advice', js: true do
    edit_page.visit

    edit_page.fill_in(
      {
        content: '',
      }
    )

    edit_page.fill_in(
      {
        content: 'New content',
      }
    )

    edit_page.save

    dilemma_advice.reload

    expect(dilemma_advice.content).to eq('<p>ContentNew content</p>')
  end

  scenario 'removes medium' do
    edit_page.visit
    expect(dilemma_advice.media.count).to eq(1)
    edit_page.remove_medium(0)

    expect(dilemma_advice.media.count).to eq(0)
  end

  scenario 'deletes dilemma advice' do
    edit_page.visit
    edit_page.remove_dilemma_advice

    dilemma_advice.reload
    expect(dilemma_advice.deleted_at).not_to eq(nil)
  end
end
