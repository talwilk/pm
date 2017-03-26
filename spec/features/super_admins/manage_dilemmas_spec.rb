require 'rails_helper'

feature 'Super admin visits dilemmas tab' do
  let!(:super_admin)   { create :super_admin }
  let!(:dilemma)       { create(:dilemma, title: 'DilemmaTitle', description: 'Descripton') }
  let!(:second_media)  { create(:file, mediable: dilemma) }
  let(:index_page)     { Page::SuperAdmin::Dilemmas::Index.new }
  let(:edit_page)      { Page::SuperAdmin::Dilemmas::Edit.new(dilemma) }

  before do
    sign_in(super_admin)
  end

  scenario 'and uses search bar' do
    index_page.visit
    expect(index_page).to have_text("##{dilemma.id}")

    index_page.fill_in 'search', with: dilemma.title + 'x'
    index_page.search
    expect(index_page).to have_content 'No results found'

    index_page.fill_in 'search', with: dilemma.title
    index_page.search
    expect(index_page).to have_content 'Search results: (1)'
    expect(index_page).to have_content "##{dilemma.id}"
  end

  scenario 'edits dilemma', js: true do
    edit_page.visit

    edit_page.fill_in(
      {
        title: '',
        description: '',
      }
    )

    edit_page.fill_in(
      {
        title: 'New title',
        description: 'New description',
      }
    )

    edit_page.save

    dilemma.reload

    expect(dilemma.title).to eq('New title')
    expect(dilemma.description).to eq('<p>DescriptonNew description</p>')
  end

  scenario 'removes medium' do
    edit_page.visit
    expect(dilemma.media.count).to eq(2)
    edit_page.remove_medium(0)

    expect(dilemma.media.count).to eq(1)
  end

  scenario 'deletes dilemma' do
    edit_page.visit
    edit_page.remove_dilemma

    dilemma.reload
    expect(dilemma.deleted_at).not_to eq(nil)
  end
end
