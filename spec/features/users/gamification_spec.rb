require 'rails_helper'

def wait_for_ajax
  Timeout.timeout(Capybara.default_max_wait_time) do
    loop until finished_all_ajax_requests?
  end
end

def finished_all_ajax_requests?
  page.evaluate_script('jQuery.active').zero?
end

def check_points(user, action)
  user.reload
  expect(user.total_points).to eq SupportedGamificationActivity.find(action)
end

def create_dilemma
  new_dilemma_page.visit
  new_dilemma_page.open_categories
  new_dilemma_page.choose_category('Architecture')
  new_dilemma_page.fill_in(
    title: Faker::Lorem.sentence,
    description: Faker::Lorem.paragraph
  )
  new_dilemma_page.choose_image_url
  new_dilemma_page.fill_in('image_url_modal_input',with: 'http://www.queness.com/resources/images/png/apple_ex.png')
  new_dilemma_page.add_url
  new_dilemma_page.submit
  expect(show_dilemma_page).to have_successful_create_dilemma_notice
end

def create_advice
  show_dilemma_page.visit(dilemma.id)
  show_dilemma_page.fill_in(content: Faker::Lorem.sentence)
  if @with_media
    show_dilemma_page.choose_file
    show_dilemma_page.browse_file
    show_dilemma_page.attach_image
  end
  show_dilemma_page.submit
end

def like_advice
  show_dilemma_page.visit(dilemma.id)
  show_dilemma_page.like
  show_dilemma_page.has_unlike
end

feature 'User', js: true do
  let!(:first_user)       { create :confirmed_user, country_iso: 'PL' }
  let!(:second_user)      { create :confirmed_user, confirmation_token: 'testtoken2', country_iso: 'PL'}
  let(:new_dilemma_page)  { Page::Dilemma::AddDilemma.new }
  let(:show_dilemma_page) { Page::Dilemma::ShowDilemma.new }
  let!(:dilemma)          { create :dilemma, user: second_user, category_list:['Architecture'] }
  let!(:advice)           { create :dilemma_advice, dilemma: dilemma, user: first_user, content: 'Myadvice' }

  scenario 'adds dilemma, gains points and recieves e-mail', :js do
    reset_mailer
    sign_in(first_user)
    create_dilemma
    check_points(Dilemma.last.user, 'create_dilemma')
  end

  context 'adds advice, gains points and recieves e-mail', :js do
    scenario 'without media' do
      reset_mailer
      sign_in(first_user)
      create_advice
      wait_for_ajax
      check_points(DilemmaAdvice.last.user, 'create_advice')
    end

    scenario 'with media' do
      reset_mailer
      @with_media = true
      sign_in(first_user)
      create_advice
      wait_for_ajax
      expect(DilemmaAdvice.last.user.total_points).to eq SupportedGamificationActivity.find('create_advice_with_media')
      expect(page).to have_content DilemmaAdvice.last.user.level
    end
  end

  scenario 'likes advice, gains points and recieves e-mail', :js do
    reset_mailer
    sign_in(second_user)
    like_advice
    travel 4381.minutes do
      IssueChosenAsBestAdviceEmailsJob.perform_now
      check_points(DilemmaAdvice.last.user, 'advice_like')
    end
  end

  scenario 'marks advice as favorite, gains points and receives e-mail' do
    reset_mailer
    sign_in(second_user)
    show_dilemma_page.visit(dilemma.id)
    show_dilemma_page.choose_favorite_advice
    show_dilemma_page.has_favorite_advice
    check_points(Dilemma.last.user, 'mark_favourite_advice')
  end

  scenario 'gets enough advices selected as favorite to receive badge (and e-mail)' do
    created_dilemmas = FactoryGirl.create_list(:dilemma, 9, user: first_user)
    created_dilemmas.each do |dilemma|
      dilemma.advices << FactoryGirl.create(:dilemma_advice, user: second_user, dilemma_id: dilemma.id)

      dilemma.favorite_dilemma_advice_id = dilemma.advices.first.id
      dilemma.favorite_advice_ends_at = Time.zone.now - 5.minutes
      dilemma.save
    end

    recent_dilemma = FactoryGirl.create(:dilemma, user: first_user)
    first_user.dilemmas.last.advices << FactoryGirl.create(:dilemma_advice, user: second_user, dilemma_id: recent_dilemma.id)

    sign_in(first_user)
    visit user_path(second_user)

    expect(page).to have_css(".dashboard-dilemma-item__rank")
    show_dilemma_page.visit(recent_dilemma.id)
    show_dilemma_page.choose_favorite_advice
    IssueChosenAsBestAdviceEmailsJob.perform_now
    second_user.reload
    expect(second_user.best_advice_badge).to eq 1
  end

  scenario 'gets enough advices liked to receive badge (and e-mail)', :js do
    reset_mailer
    recent_dilemma = FactoryGirl.create(:dilemma, user: first_user)
    created_advices = FactoryGirl.create_list(:dilemma_advice, 9, dilemma_id: recent_dilemma.id, user: second_user)

    sign_in(second_user)
    show_dilemma_page.visit(recent_dilemma.id)
    show_dilemma_page.fill_in(content: Faker::Lorem.sentence)
    show_dilemma_page.submit
    wait_for_ajax
    check_points(DilemmaAdvice.last.user, 'create_advice')
    first_user.reload
    expect(first_user.dilemma_advices_badge).to eq 1
    open_email(first_user.email, with_subject: 'You achieved Dilemma Advices Badge!')
    click_first_link_in_email
    expect(page).to have_css(".dashboard-dilemma-item__rank")
  end
end
