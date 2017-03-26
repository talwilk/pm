require 'rails_helper'

feature 'User signs in' do
  let!(:super_admin)             { create :super_admin, email: 'super@admin.email', password: 'password' }
  let(:super_admin_home_page)    { Page::SuperAdmin::Dashboard.new }
  let(:super_admin_sign_in_page) { Page::SuperAdmin::SignIn.new }
  let(:home_page)                { Page::User::Home.new }

  scenario 'with valid e-mail and password' do
    super_admin_sign_in_page.visit

    super_admin_sign_in_page.fill_in(email: 'super@admin.email', password: 'password')
    super_admin_sign_in_page.submit

    expect(super_admin_home_page).to have_successful_sign_in_notice
  end

  scenario 'with invalid/blank e-mail' do
    super_admin_sign_in_page.visit

    super_admin_sign_in_page.fill_in(email: 'wrong@admin.email', password: 'password')
    super_admin_sign_in_page.submit

    expect(super_admin_sign_in_page).to have_unsuccessful_sign_in_alert
  end

  scenario 'with invalid/blank password' do
    super_admin_sign_in_page.visit

    super_admin_sign_in_page.fill_in(email: 'wrong@admin.email', password: 'wrongpassword')
    super_admin_sign_in_page.submit

    expect(super_admin_sign_in_page).to have_unsuccessful_sign_in_alert
  end

  scenario 'and signs out' do
    super_admin_sign_in_page.visit

    super_admin_sign_in_page.fill_in(email: 'super@admin.email', password: 'password')
    super_admin_sign_in_page.submit

    super_admin_home_page.sign_out
    expect(page).to have_current_path(root_path)
  end
end
