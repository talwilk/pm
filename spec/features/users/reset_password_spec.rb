require 'rails_helper'

feature 'User resets password' do
  scenario 'with invalid email' do
    reset_password_page = Page::User::Authentication::ResetPassword.new

    user = create(:user, email: 'first@user.email', password: 'password')

    reset_password_page.visit

    reset_password_page.fill_in(email: 'second@user.email')
    reset_password_page.submit

    expect(reset_password_page).to have_invalid_email_alert
  end

  scenario 'with valid email' do
    home_page = Page::User::Home.new
    sign_in_page = Page::User::Authentication::SignIn.new
    reset_password_page = Page::User::Authentication::ResetPassword.new
    new_password_page = Page::User::Authentication::NewPassword.new

    user = create(:user, email: 'first@user.email', password: 'password')

    reset_password_page.visit

    reset_password_page.fill_in(email: 'first@user.email')
    reset_password_page.submit

    open_email(user.email, with_subject: 'Password-rest')
    click_first_link_in_email

    new_password_page.fill_in(password: '', password_confirmation: '')
    new_password_page.submit

    expect(new_password_page).to have_blank_password_alert

    new_password_page.fill_in(password: 'pass', password_confirmation: 'pass')
    new_password_page.submit

    expect(new_password_page).to have_invalid_password_alert

    new_password_page.fill_in(password: 'password', password_confirmation: 'wrongpassword')
    new_password_page.submit

    expect(new_password_page).to have_invalid_password_confirmation_alert

    new_password_page.fill_in(password: 'newpassword', password_confirmation: 'newpassword')
    new_password_page.submit
    user.reload
    expect(user.valid_password?('newpassword')).to eq(true)
  end
end
