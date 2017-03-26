require 'rails_helper'

feature 'User adds dilemma' do
  let!(:user) { create :confirmed_user, email: 'regular2@user.email', password: 'password'}
  let!(:user_profile) {create :user_profile, user: user}
  let!(:dilemma) {create :dilemma, user: user}
  let(:new_page) { Page::Dilemma::AddDilemma.new }
  let(:show_page) { Page::Dilemma::ShowDilemma.new }
  let(:home_page) { Page::User::Home.new }
  let(:billing_page) { Page::PaymentPlanTransaction::ManagePaymentPlans.new }
  let(:sign_in_page) { Page::User::Authentication::SignIn.new }

  scenario 'With filled all fields', js: true do
    sign_in(user)
    new_page.visit
    new_page.open_categories
    new_page.choose_category('Architecture')
    new_page.fill_in(
              title: Faker::Lorem.sentence,
              description: Faker::Lorem.paragraph
    )
    new_page.choose_file
    new_page.browse_file
    new_page.attach_image
    new_page.choose_image_url
    new_page.fill_in('image_url_modal_input',with: 'http://www.queness.com/resources/images/png/apple_ex.png')
    new_page.add_url
    new_page.choose_youtube_video
    new_page.fill_in('youtube_url_modal_input',with: 'https://www.youtube.com/watch?v=DqPoBB5sxhc')
    new_page.add_url
    new_page.submit
    expect(UserPointsLog).to exist(points_amount: SupportedGamificationActivity.find('create_dilemma'), activity: 'create_dilemma', user: user, gamificable_type: 'Dilemma', super_admin_id: nil)
  end

  scenario 'With not filled input fields', :js do
    sign_in(user)
    new_page.visit
    new_page.fill_in(
      title: '',
      description: ''
    )
    new_page.choose_file
    new_page.browse_file
    new_page.attach_image
    new_page.choose_image_url
    new_page.fill_in('image_url_modal_input', with: 'http://www.queness.com/resources/images/png/apple_ex.png')
    new_page.add_url
    new_page.choose_youtube_video
    new_page.fill_in('youtube_url_modal_input', with: 'https://www.youtube.com/watch?v=DqPoBB5sxhc')
    new_page.add_url
    new_page.submit
    expect(new_page).to have_unsuccessful_create_dilemma_notice
  end

  scenario 'With not filled media', js:true do
    sign_in(user)
    new_page.visit
    new_page.fill_in(
      title: Faker::Lorem.sentence,
      description: Faker::Lorem.paragraph
    )
    new_page.submit
    expect(new_page).to have_unsuccessful_create_dilemma_notice
  end

  scenario 'With cancel and empty links', js:true do
    sign_in(user)
    new_page.visit
    new_page.choose_image_url
    expect(new_page).to have_remove_input_link
    new_page.cancel
    expect(new_page).to_not have_remove_input_link
    new_page.choose_youtube_video
    expect(new_page).to have_remove_input_link
    new_page.cancel
    expect(new_page).to_not have_remove_input_link
    new_page.choose_file
    expect(new_page).to have_remove_input_link
    new_page.cancel
    expect(new_page).to_not have_remove_input_link
    new_page.choose_image_url
    expect(new_page).to have_remove_input_link
    new_page.fill_in('image_url_modal_input', with: '')
    new_page.add_url
    expect(new_page).to have_remove_input_link
  end

  scenario 'With added first dilemma', js:true do
    user.first_dilemma_added = true
    user.save
    sign_in(user)
    new_page.visit
    expect(billing_page).to have_choose_plan_notice
  end

  scenario 'not logged in ' do
    new_page.visit
    expect(sign_in_page).to have_need_to_login_notice
  end

  scenario 'not confirmed' do
    user.confirmed_at = nil
    user.save
    sign_in(user)
    new_page.visit
    expect(home_page).to have_not_confirmed_or_subscribed_notice
  end
end
