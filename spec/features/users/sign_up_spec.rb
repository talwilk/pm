require 'rails_helper'

feature 'User signs up' do
  let!(:user)               { create :user, email: 'second@user.email' }
  let(:home_page)           { Page::User::Home.new }
  let(:sign_up_page)        { Page::User::Authentication::SignUp.new }

  def set_username(user)
    new_username = base_username = user[:email].split('@').first

    return new_username
  end

  scenario 'with valid e-mail and password' do
    new_user = attributes_for(:user)
    pass = new_user[:password]
    sign_up_page.visit

    sign_up_page.fill_in(email: new_user[:email], password: pass)

    expect do
      sign_up_page.submit
    end.to change(User, :count).by(1)

    user = User.last
    expect(user.email).to eq(new_user[:email])

    first_name = set_username(new_user)
    expect(user.profile.first_name).to eq(first_name)
  end

  scenario 'with invalid e-mail' do
    new_user = build(:user)
    pass = new_user.password

    sign_up_page.visit

    sign_up_page.fill_in(email: 'invaliduser.email', password: pass)
    sign_up_page.submit

    expect(sign_up_page).to have_invalid_email_alert
  end

  scenario 'with blank e-mail' do
    new_user = build(:user)
    pass = new_user.password

    sign_up_page.visit

    sign_up_page.fill_in(email: '', password: pass)
    sign_up_page.submit

    expect(sign_up_page).to have_blank_email_alert
  end

  scenario 'with taken e-mail' do
    new_user = build(:user)
    pass = new_user.password

    sign_up_page.visit

    sign_up_page.fill_in(email: 'second@user.email', password: pass)
    sign_up_page.submit

    expect(sign_up_page).to have_taken_email_alert
  end

  scenario 'with invalid password' do
    new_user = build(:user)
    pass = new_user.password

    sign_up_page.visit

    sign_up_page.fill_in(email: new_user.email, password: '1234567')
    sign_up_page.submit

    expect(sign_up_page).to have_invalid_password_alert
  end

  scenario 'with blank password' do
    new_user = build(:user)
    pass = new_user.password

    sign_up_page.visit

    sign_up_page.fill_in(email: new_user.email, password: '')
    sign_up_page.submit

    expect(sign_up_page).to have_blank_password_alert
  end

  scenario 'with facebook' do
    valid_facebook_login_setup('first@user.email')
    expect(User).not_to exist(email: 'first@user.email')
    sign_up_page.visit
    sign_up_page.facebook_sign_in
    expect(User).to exist(email: 'first@user.email')
  end

  scenario 'incorrectly when facebook auth fails' do
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:facebook] = :invalid_credentials
    sign_up_page.visit
    sign_up_page.facebook_sign_in
    expect(sign_up_page).to have_invalid_omniauth_credentials_alert
  end

  scenario 'with google plus' do
    valid_google_login_setup('google@user.email')
    expect(User).not_to exist(email: 'google@user.email')
    sign_up_page.visit
    sign_up_page.google_oauth2_sign_in
    expect(User).to exist(email: 'google@user.email')
  end

  scenario 'incorrectly when google auth fails' do
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:google_oauth2] = :invalid_credentials
    sign_up_page.visit
    sign_up_page.google_oauth2_sign_in
    expect(sign_up_page).to have_invalid_omniauth_credentials_alert
  end
end
