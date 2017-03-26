require 'rails_helper'

feature 'User manages with payments' do
  scenario 'and chooses a plan' do
    user = create(:confirmed_user, email: 'regular@user.email', password: 'password')

    billing_page = Page::PaymentPlanTransaction::ManagePaymentPlans.new

    # user chooses a plan
    sign_in(user)
    billing_page.visit
    billing_page.choose_small_plan
    expect(billing_page).to have_successful_chosen_plan_notice

    # user visits billing page with chosen plan
    billing_page.visit
    expect(billing_page).to have_chosen_plan_notice
  end

  scenario 'and adds 2 dilemmas without plan', js: true do
    user = create(:confirmed_user, email: 'regular@user.email', password: 'password')

    billing_page = Page::PaymentPlanTransaction::ManagePaymentPlans.new
    new_dilemma_page = Page::Dilemma::AddDilemma.new
    show_page = Page::Dilemma::ShowDilemma.new

    sign_in(user)
    new_dilemma_page.visit
    new_dilemma_page.open_categories
    new_dilemma_page.choose_category('Architecture')
    new_dilemma_page.fill_in(
      title: Faker::Lorem.sentence,
      description: Faker::Lorem.paragraph
    )
    new_dilemma_page.choose_youtube_video
    new_dilemma_page.fill_in('youtube_url_modal_input',with: 'https://www.youtube.com/watch?v=DqPoBB5sxhc')
    new_dilemma_page.add_url
    new_dilemma_page.submit
    expect(show_page).to have_successful_create_dilemma_notice
    new_dilemma_page.visit
    expect(billing_page).to have_choose_plan_notice
  end
end
