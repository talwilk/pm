require 'rails_helper'

feature 'User adds advice', js: true do
  let!(:user) { create :confirmed_user, email: 'regular2@user.email', password: 'password'}
  let!(:user_not_owner) { create :confirmed_user, id: 123, email: 'not_regular@user.email', password: 'password', confirmation_token: 'testtoken2'}
  let!(:user_profile) {create :user_profile, user: user }
  let!(:dilemma) {create :dilemma, user: user, category_list:['Architecture']}
  let!(:dilemma_2) {create :dilemma, user: user, category_list:['Architecture']}
  let!(:not_owned_dilemma) {create :dilemma, user: user_not_owner}
  let(:show_page) { Page::Dilemma::ShowDilemma.new }
  let(:sign_in_page) {Page::User::Authentication::SignIn.new }

  scenario 'to dilemma added by another user', js:true do
    sign_in(user_not_owner)
    show_page.visit(dilemma.id)
    show_page.fill_in(content: 'This is a content')
    show_page.submit
    show_page.have_content
  end

  scenario 'with media to dilemma added by another user', js:true do
    sign_in(user_not_owner)
    show_page.visit(dilemma.id)
    show_page.fill_in(content: 'This is a content')
    show_page.choose_image_url
    show_page.fill_in('image_url_modal_input',with: 'http://www.queness.com/resources/images/png/apple_ex.png')
    show_page.add_url
    show_page.choose_youtube_video
    show_page.fill_in('youtube_url_modal_input',with: 'https://www.youtube.com/watch?v=DqPoBB5sxhc')
    show_page.add_url
    show_page.submit
    show_page.have_content
  end

  scenario 'with empty content to dilemma added by another user' do
    sign_in(user_not_owner)
    show_page.visit(dilemma.id)
    show_page.fill_in(content: '')
    show_page.submit
    expect(show_page).to have_fill_content_notice
  end

  scenario 'to dilemma added by himself' do
    sign_in(user)
    show_page.visit(dilemma.id)
    expect(show_page).to have_disabled_advice_create_button_notice
  end

  scenario 'to expired dilemma' do
    travel 4321.minutes
    sign_in(user_not_owner)
    show_page.visit(dilemma.id)
    expect(show_page).to have_disabled_advice_create_button_notice
    travel_back
  end
end
