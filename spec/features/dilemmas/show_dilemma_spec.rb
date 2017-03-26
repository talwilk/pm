require 'rails_helper'

feature 'User visits dilemma' do
  scenario "user visits dilemma" do
    user = create :confirmed_user, email: 'regular@user.email', password: 'password'
    user_not_owner = create :confirmed_user, id: 123, email: 'not_regular@user.email', password: 'password', confirmation_token: 'testtoken2'
    dilemma = create :dilemma, user: user, category_list:['Architecture']
    not_owned_dilemma = create :dilemma, user: user_not_owner
    advice = create :dilemma_advice, dilemma: dilemma, user: user_not_owner
    show_page = Page::Dilemma::ShowDilemma.new

    # not logged in
    show_page.visit(dilemma.id)
    show_page.can_not_remove_dilemma
    show_page.can_not_edit_dilemma
    show_page.has_no_favorite_advice_link

    # owned dilemma
    sign_in(user)
    show_page.visit(dilemma.id)
    show_page.can_remove_dilemma
    show_page.can_edit_dilemma

    # has meta tags
    show_page.has_meta_tags

    # has advices
    show_page.has_dilemma_advices

    # has no cover photo
    show_page.not_set_cover_photo

    # has similar user dilemmas
    show_page.has_similar_user_dilemmas
    show_page.has_similar_category_dilemmas

    # chooses favorite advice
    show_page.choose_favorite_advice
    show_page.has_favorite_advice
    expect(Dilemma).to exist(favorite_dilemma_advice_id: advice.id)

    # sees commented dilemma
    dilemma.update_columns(first_advice_added: true)
    show_page.visit(dilemma.id)
    show_page.edit_dilemma
    expect(show_page).to have_disabled_dilemma_notice

    # opens share modal
    show_page.open_share_modal
    show_page.has_facebook_share
    show_page.has_twitter_share
    show_page.has_google_share

    # not owner
    show_page.visit(not_owned_dilemma.id)
    show_page.can_not_remove_dilemma
    show_page.can_not_edit_dilemma
    show_page.has_no_favorite_advice_link
  end

  scenario "user removes dilemma", js: true do
    user = create :confirmed_user, email: 'regular@user.email', password: 'password'
    dilemma = create :dilemma, user: user, category_list:['Architecture']

    show_page = Page::Dilemma::ShowDilemma.new
    home_page = Page::User::Home.new

    sign_in(user)
    show_page.visit(dilemma.id)
    show_page.remove_dilemma
    expect(Dilemma).not_to exist(id: dilemma.id)
  end

  scenario "user visits expired dilemma", js: true do
    user = create :confirmed_user, email: 'regular@user.email', password: 'password'
    user_not_owner = create :confirmed_user, id: 123, email: 'not_regular@user.email', password: 'password', confirmation_token: 'testtoken2'
    dilemma = create :dilemma, user: user, category_list:['Architecture']
    not_owned_dilemma = create :dilemma, user: user_not_owner
    show_page = Page::Dilemma::ShowDilemma.new

    travel 4321.minutes
    sign_in(user)

    # owned
    show_page.visit(not_owned_dilemma.id)
    show_page.closed_dilemma

    # not owner
    show_page.visit(dilemma.id)
    show_page.can_not_edit_dilemma
    show_page.can_not_remove_dilemma

    travel_back

    # after 5 days not possible to set favorite advice
    travel 121.hours
    show_page.visit(dilemma.id)
    show_page.has_no_favorite_advice_link
    travel_back
  end
end
