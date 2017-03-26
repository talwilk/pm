require 'rails_helper'

def wait_for_ajax
  Timeout.timeout(Capybara.default_max_wait_time) do
    loop until finished_all_ajax_requests?
  end
end

def finished_all_ajax_requests?
  page.evaluate_script('jQuery.active').zero?
end

feature 'User views dashboard' do
  let(:dashboard_page)   { Page::User::Home.new }
  let(:dilemma_show_page){ Page::Dilemma::ShowDilemma.new }

  let!(:user)           { create :user, id: 1, country_iso: 'RD' }
  let!(:guru_user)      { create :guru_user, id: 2, country_iso: 'RD' }
  let!(:second_user)    { create :user, id: 3, country_iso: 'RD' }
  let!(:first_dilemma)  { create :dilemma, title: 'First Dilemma', description: 'Lorem ipsum dolor', user: user}
  let!(:second_dilemma) { create :dilemma, title: 'Second Dilemma', user: user }
  let!(:third_dilemma)  { create :dilemma, title: 'Third Dilemma', user: user}
  let!(:closed_dilemma) { create :dilemma, title: 'Closed Dilemma', user: user, ends_at: Time.zone.now - 4.days }
  let!(:fourth_dilemma) { create :dilemma, title: 'Fourth Dilemma', user: user }
  let!(:fifth_dilemma)  { create :dilemma, title: 'Fifth Dilemma', user: user, category_list: ['cladding', 'restoration'] }
  let!(:sixth_dilemma)  { create :dilemma, title: 'Sixth Dilemma', user: guru_user, category_list: ['cladding', 'feng_shui'] }
  let!(:seventh_dilemma){ create :dilemma, title: 'Seventh Dilemma', user: user }
  let!(:eighth_dilemma) { create :dilemma, title: 'Eighth Dilemma', user: user }
  let!(:nineth_dilemma) { create :dilemma, title: 'Nineth Dilemma', user: guru_user }

  scenario "user visits dashboard" do
    sign_in(user)
    dashboard_page.visit

    # sees all dilemmas, featured gurus and trending dilemmas
    expect(dashboard_page).to have_content 'Eighth Dilemma'
    expect(dashboard_page).not_to have_content 'Sixth Dilemma'
    expect(dashboard_page).to have_load_more_button
    expect(dashboard_page).to have_featured_gurus_label
    expect(dashboard_page).to have_trending_dilemmas_label

    # clicks load more
    dashboard_page.load_more_dilemmas
    wait_for_ajax
    click_on "First Dilemma"
    expect(dilemma_show_page).to have_content 'Lorem ipsum dolor'
  end

  scenario 'and has no dilemmas, so clicks on link to add one' do
    sign_in(second_user)
    dashboard_page.visit
    expect(dashboard_page).to have_call_to_post_first_dilemma_message
  end
end
