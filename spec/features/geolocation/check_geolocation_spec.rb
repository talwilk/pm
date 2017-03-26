require 'rails_helper'

feature 'Geolocation affects' do
  scenario "user from another country visits page", js: true do
    Country.create(country_iso: "AT", enabled_at: Time.zone.now)
    user = create(:confirmed_user, email: 'regular@user.email', password: 'password')
    user_2 = create(:confirmed_user, email: 'regular_1@user.email', password: 'password', confirmation_token: 'testtoken2')
    user_from_other_country = create(:confirmed_user, email: 'regular_2@user.email', password: 'password', confirmation_token: 'testtoken3', country_iso: 'AT')
    user_from_other_country_2 = create(:confirmed_user, email: 'regular_3@user.email', password: 'password', confirmation_token: 'testtoken4', country_iso: 'AT')

    first_dilemma = create(:dilemma, user: user, title: 'First Dilemma', category_list:['Architecture'])
    second_dilemma = create(:dilemma, user: user_2, title: 'Second Dilemma', category_list:['Architecture'])
    third_dilemma = create(:dilemma, user: user_from_other_country, title: 'Third Dilemma', category_list:['Architecture'])
    fourth_dilemma = create(:dilemma, user: user_from_other_country_2, title: 'Fourth Dilemma', category_list:['Architecture'])
    advice = create(:dilemma_advice, dilemma: second_dilemma, user: user)
    advice = create(:dilemma_advice, dilemma: third_dilemma, user: user_from_other_country_2)

    show_page = Page::Dilemma::ShowDilemma.new
    edit_page = Page::Dilemma::EditDilemma.new
    home_page = Page::User::Home.new

    # views dilemma
    sign_in(user_from_other_country)
    show_page.visit(first_dilemma.id)
    expect(show_page).to have_content 'First Dilemma'

    # disable country
    country = Country.find("AT")
    country.update_attributes(enabled_at: nil, super_admin_id: nil)

    # tries to add dilemma
    home_page.visit
    home_page.add_dilemma
    expect(home_page).to have_disabled_country_notice

    # visits own dilemma
    show_page.visit(third_dilemma.id)
    show_page.has_no_favorite_advice_link
    show_page.remove_dilemma
    expect(home_page).to have_disabled_country_notice

    # tries to edit own dilemma
    edit_page.visit(third_dilemma.id)
    expect(home_page).to have_disabled_country_notice

    # other user does not see dilemma actions
    sign_in(user_from_other_country_2)
    show_page.visit(third_dilemma.id)
    show_page.has_no_like_div
    show_page.has_no_advice_field
  end
end
