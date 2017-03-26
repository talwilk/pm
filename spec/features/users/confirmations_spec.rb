require 'rails_helper'

feature 'User' do
  let!(:unconfirmed_user)   { create :unconfirmed_user}
  let(:home_page)           { Page::User::Home.new }

  scenario 'resend confirmation email' do
    sign_in(unconfirmed_user)
    token = unconfirmed_user.confirmation_token
    home_page.visit
    expect(home_page).to have_unconfirmed_notice
    home_page.resend_token
    unconfirmed_user.reload
    expect(unconfirmed_user.confirmation_token).to_not eq(token)
  end

  scenario 'confirmed token with signed user' do
    open_email(unconfirmed_user.email, with_subject: 'Welcome to Dilemma Guru!')
    click_first_link_in_email
    expect(current_path).to eq new_dilemma_path
  end

  scenario 'confirmed token with unsigned user' do
    open_email(unconfirmed_user.email, with_subject: 'Welcome to Dilemma Guru!')
    click_first_link_in_email
    expect(current_path).to eq new_dilemma_path
  end

  scenario 'cofirmed with expirated token' do
    travel 4321.minutes do
      open_email(unconfirmed_user.email, with_subject: 'Welcome to Dilemma Guru!')
      click_first_link_in_email
      expect(home_page).to have_expired_token_notice
    end
  end

  scenario 'cofirmed with invalid token' do
    unconfirmed_user.confirmation_token = 'asdasd'
    unconfirmed_user.save
    open_email(unconfirmed_user.email, with_subject: 'Welcome to Dilemma Guru!')
    click_first_link_in_email
    expect(home_page).to have_invalid_token_notice
  end

  scenario 'confirmed account multiple times' do
    open_email(unconfirmed_user.email, with_subject: 'Welcome to Dilemma Guru!')
    click_first_link_in_email
    open_email(unconfirmed_user.email, with_subject: 'Welcome to Dilemma Guru!')
    click_first_link_in_email
    expect(home_page).to have_already_confirmed_account_notice
  end
end
