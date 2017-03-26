require 'rails_helper'

feature 'User views dilemmas index' do
  let(:home_page)           { Page::User::Home.new }
  let(:dilemmas_index_page) { Page::Dilemma::DilemmasIndex.new }
  let(:dilemma_show_page)   { Page::Dilemma::ShowDilemma.new }

  let!(:user)           { create :user, id: 1, country_iso: 'RD' }
  let!(:guru)           { create :guru_user, id: 2, country_iso: 'RD' }
  let!(:first_dilemma)  { create :dilemma, title: 'First Dilemma', user: user}
  let!(:second_dilemma) { create :dilemma, title: 'Second Dilemma', user: user }
  let!(:third_dilemma)  { create :dilemma, title: 'Third Dilemma', user: user}
  let!(:closed_dilemma) { create :dilemma, title: 'Closed Dilemma', user: user, ends_at: Time.zone.now - 4.days }
  let!(:fourth_dilemma) { create :dilemma, title: 'Fourth Dilemma', user: user, category_list: ['architecture', 'feng_shui'] }
  let!(:fifth_dilemma)  { create :dilemma, title: 'Fifth Dilemma', user: user, category_list: ['architecture', 'restoration'] }
  let!(:sixth_dilemma)  { create :dilemma, title: 'Sixth Dilemma', user: user }
  let!(:seventh_dilemma){ create :dilemma, title: 'Seventh Dilemma', user: user }
  let!(:eighth_dilemma) { create :dilemma, title: 'Eighth Dilemma', description: 'Lorem ipsum dolor', user: user }

  scenario "users searches dilemmas" do
    dilemmas_index_page.visit

    # sees all dilemmas, featured gurus and trending dilemmas
    expect(dilemmas_index_page).to have_content 'Eighth Dilemma'
    expect(dilemmas_index_page).not_to have_content 'Closed Dilemma'
    expect(dilemmas_index_page).to have_load_more_button
    expect(dilemmas_index_page).to have_featured_gurus_label
    expect(dilemmas_index_page).to have_trending_dilemmas_label

    # loads more results
    dilemmas_index_page.load_more_dilemmas
    expect(dilemmas_index_page).to have_content 'Fourth Dilemma'

    # searches for Fifth Dilemma
    fill_in 'search', with: 'Fifth'
    dilemmas_index_page.search
    expect(dilemmas_index_page).to have_content 'Fifth Dilemma'
    expect(dilemmas_index_page).not_to have_content 'Sixth Dilemma'

    # searches for non existing record
    fill_in 'search', with: 'Nineth'
    dilemmas_index_page.search
    expect(dilemmas_index_page).to have_no_results_message

    # filters closed only dilemmas
    dilemmas_index_page.visit
    select 'Closed', from: 'dilemmas'
    select 'Newest', from: 'sort_by'
    expect(dilemmas_index_page).to have_content 'Closed Dilemma'
    expect(dilemmas_index_page).not_to have_content 'Sixth Dilemma'

    # filters dilemmas by category
    dilemmas_index_page.visit
    select 'Feng shui', from: 'category', visible: false
    select 'Restoration', from: 'category', visible: false
    expect(dilemmas_index_page).to have_content 'Fifth Dilemma'
    expect(dilemmas_index_page).to have_content 'Fourth Dilemma'
    expect(dilemmas_index_page).not_to have_content 'Sixth Dilemma'
  end

  scenario 'and opens one of dilemmas' do
    sign_in(user)
    dilemmas_index_page.visit
    expect(dilemmas_index_page).to have_content 'Sixth Dilemma'
    dilemmas_index_page.show_dilemma
    expect(dilemma_show_page).to have_content 'Sixth Dilemma'
  end
end
