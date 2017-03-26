require 'rails_helper'

feature 'User signs in' do
  let!(:user)               { create :user, email: 'first@user.email', password: 'password' }
  let!(:unconfirmed_user)   { create :unconfirmed_user, email: 'unconfirmed@user.email', password: 'password' }
  let(:home_page)           { Page::User::Home.new }
  let(:sign_in_page)        { Page::User::Authentication::SignIn.new }

  scenario 'with valid e-mail and password' do
    sign_in_page.visit

    sign_in_page.fill_in(email: 'first@user.email', password: 'password')
    sign_in_page.submit
    expect(LoginHistory).to exist(login_method: 'email', successful_login: true)
  end

  scenario 'with invalid e-mail' do
    sign_in_page.visit

    sign_in_page.fill_in(email: 'second@user.email', password: 'password')
    sign_in_page.submit

    expect(home_page).to have_unsuccessful_sign_in_alert
  end

  scenario 'with invalid password' do
    sign_in_page.visit

    sign_in_page.fill_in(email: 'first@user.email', password: 'password2')
    sign_in_page.submit

    expect(home_page).to have_unsuccessful_sign_in_alert
    expect(LoginHistory).to exist(login_method: 'email', successful_login: false)
  end

  scenario 'and signs out' do
    sign_in_page.visit

    sign_in_page.fill_in(email: 'first@user.email', password: 'password')
    sign_in_page.submit

    home_page.sign_out
    expect(page).to have_current_path(root_path)
  end

  scenario 'with facebook' do
    valid_facebook_login_setup('second@user.email')
    sign_in_page.visit
    sign_in_page.facebook_sign_in
    expect(LoginHistory).to exist(login_method: 'facebook', successful_login: true)
  end

  scenario 'incorrectly when facebook auth fails' do
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:facebook] = :invalid_credentials
    sign_in_page.visit
    sign_in_page.facebook_sign_in
    expect(sign_in_page).to have_invalid_omniauth_credentials_alert
  end

  scenario 'with google plus', js:true do
    valid_google_login_setup('third@user.email')
    sign_in_page.visit
    sign_in_page.google_oauth2_sign_in
    expect(LoginHistory).to exist(login_method: 'google+', successful_login: true)
  end

  scenario 'incorrectly when google auth fails', js: true do
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:google_oauth2] = :invalid_credentials
    sign_in_page.visit
    sign_in_page.google_oauth2_sign_in
    expect(sign_in_page).to have_invalid_omniauth_credentials_alert
  end

  scenario 'with existing email with google', js:true do
    valid_google_login_setup('first@user.email')
    sign_in_page.visit
    sign_in_page.google_oauth2_sign_in
  end

  scenario 'with existing email with facebook', js:true do
    valid_facebook_login_setup('first@user.email')
    sign_in_page.visit
    sign_in_page.facebook_sign_in
  end

  scenario 'with unconfirmed account' do
    sign_in_page.visit
    sign_in_page.fill_in(email: 'unconfirmed@user.email', password: 'password')
    sign_in_page.submit
    expect(home_page).to have_unconfirmed_notice
  end
end
