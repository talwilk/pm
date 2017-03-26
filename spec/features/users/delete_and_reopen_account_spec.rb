require 'rails_helper'

feature 'User' do
  let!(:user)                   { create :user, email: 'second@user.email',
                                                password: 'password'
                                              }
  let!(:deleted_user)           { create :user, email: 'third@user.email',
                                                password: 'password',
                                                deleted_at: Faker::Time.backward
                                              }
  let(:home_page)               { Page::User::Home.new }
  let(:sign_up_page)            { Page::User::Authentication::SignUp.new }
  let(:sign_in_page)            { Page::User::Authentication::SignIn.new }
  let(:account_management_page) { Page::User::AccountManagement::AccountManagement.new }
  let(:edit_profile_page)       { Page::UserProfile::EditUserProfile.new}

  def get_reopen_account_token
    expect(User.only_deleted).to exist(email: 'third@user.email')
    reset_mailer

    sign_up_page.visit
    sign_up_page.fill_in(email: 'third@user.email')
    sign_up_page.submit
  end

  def try_to_use_reopen_account_token
    open_email(deleted_user.email, with_subject: "Let's get things rolling")
    click_first_link_in_email
  end

  scenario 'deletes his account and tries to sign in to it' do
    sign_in(user)
    edit_profile_page.visit
    edit_profile_page.delete_account
    expect(User).not_to exist(email: 'second@user.email')
    expect(User.only_deleted).to exist(email: 'second@user.email')
    sign_in_page.visit
    sign_in_page.fill_in(email: 'second@user.email', password: 'password')
    sign_in_page.submit
    expect(home_page).to have_unsuccessful_sign_in_alert
  end

  scenario 'reopens his account' do
    get_reopen_account_token
    try_to_use_reopen_account_token
    expect(User.only_deleted).not_to exist(email: 'third@user.email')
    expect(User).to exist(email: 'third@user.email')
  end

  scenario 'tries to reopen account after his token expired' do
    get_reopen_account_token

    travel 4381.minutes do
      try_to_use_reopen_account_token
      expect(sign_in_page).to have_expired_reopening_token_notice
      expect(User.only_deleted).to exist(email: 'third@user.email')
    end
  end

  scenario 'tries to reopen account with invalid/used token' do
    get_reopen_account_token
    try_to_use_reopen_account_token
    try_to_use_reopen_account_token
    expect(sign_in_page).to have_invalid_reopening_token_notice
  end
end
