require 'rails_helper'

feature 'User edits dilemma' do
  let!(:user) { create :confirmed_user, email: 'regular@user.email', password: 'password'}
  let!(:user_not_owner) { create :confirmed_user, id: 123, email: 'not_regular@user.email', password: 'password', confirmation_token: 'testtoken2'}
  let!(:user_profile) {create :user_profile, user: user }
  let!(:dilemma) {create :dilemma, user: user, description: 'Description'}
  let!(:not_owned_dilemma) {create :dilemma, user: user_not_owner}
  let!(:media) {create :youtube, mediable: dilemma}
  let!(:media_2) {create :file, mediable: dilemma}
  let!(:media_3) {create :image, mediable: dilemma}
  let(:edit_page) { Page::Dilemma::EditDilemma.new }
  let(:show_page) { Page::Dilemma::ShowDilemma.new }
  let(:home_page) { Page::User::Home.new }
  let(:sign_in_page) {Page::User::Authentication::SignIn.new }

  scenario 'With not filled input fields', :js do
    sign_in(user)
    edit_page.visit(dilemma.id)
    edit_page.fill_in(
      title: '',
      description: ''
    )
    edit_page.choose_file
    edit_page.browse_file
    edit_page.attach_image
    edit_page.choose_image_url
    edit_page.fill_in('image_url_modal_input', with: 'http://www.queness.com/resources/images/png/apple_ex.png')
    edit_page.add_url
    edit_page.choose_youtube_video
    edit_page.fill_in('youtube_url_modal_input', with: 'https://www.youtube.com/watch?v=DqPoBB5sxhc')
    edit_page.add_url
    edit_page.submit
    expect(edit_page).to have_unsuccessful_update_dilemma_notice
  end

  scenario 'With not filled media but with existing', js:true do
    sign_in(user)
    edit_page.visit(dilemma.id)
    edit_page.fill_in(
      title: 'Title',
      description: 'New description'
    )
    edit_page.submit
    dilemma.reload
    expect(dilemma.title).to eq('Title')
    expect(dilemma.description).to eq('<p>DescriptionNew description</p>')
  end

  scenario 'with remove media' do
    sign_in(user)
    count = Medium.count
    edit_page.visit(dilemma.id)
    edit_page.remove_media
    expect(Medium).to_not eq(count)
  end

  scenario 'not logged in ' do
    edit_page.visit(dilemma.id)
    expect(sign_in_page).to have_need_to_login_notice
  end

  scenario 'as not owner' do
    sign_in(user)
    edit_page.visit(not_owned_dilemma.id)
    expect(home_page).to have_not_possible_to_enter_page_notice
  end

  scenario 'disabled' do
    dilemma.first_advice_added = true
    dilemma.save
    sign_in(user)
    edit_page.visit(dilemma.id)
    expect(show_page).to have_disabled_dilemma_notice
  end

  scenario 'with set cover' do
    cover_photo = dilemma.cover_photo
    sign_in(user)
    edit_page.visit(dilemma.id)
    edit_page.change_cover
    dilemma.reload
    expect(dilemma.cover_photo).to_not eq(cover_photo)
  end
end
